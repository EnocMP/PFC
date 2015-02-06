#include "m_pd.h"
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

#define PARAMETERS 300 //number of parameters that can be stored in a single 
//preset
#define PRESETS 15 //maximum number of presets

#define DEFAULT_PARAMETERS 1
#define NAME_LENGTH 50

/***************************CLASS DECLARATION***************************/
static t_class *SoundManagerEngine_class; //create SoundManagerEngine class
/***DATA SPACE***/
typedef struct _SoundManagerEngine {
  t_object x_obj;	//object properties for PD environment
  int ParameterNum;
  int PresetNum; //Presets Loaded in file
  int CurrentPreset; //Selected Preset
  int InitializedParameters; //Number of initialized parameters
  int flag; //enables the input of data, used when loading
  t_symbol *NewName, *Bank, *DefaultSymbol;
  t_symbol s1, s2, s3;
   
  int vectorID[PARAMETERS];
  t_float ID;

  
  //Outlets
  t_outlet *ValueOut, *IDout, *SymbolOut, *PresetNumberOut; //outputs

  //char PresetName[PRESETS][NAME_LENGTH];
  char *PresetName[PRESETS];
  char *PresetBank;
  float DataBase[PRESETS][PARAMETERS];
  float TempDataBase[PARAMETERS];
} 
t_SoundManagerEngine;



int SavePresetFile (char *file, t_SoundManagerEngine *x);
int LoadPresetFile (char *file, t_SoundManagerEngine *x);
int CreatePresetFile (char *file, t_SoundManagerEngine *x);
int HashFunction(t_SoundManagerEngine *x, int input);


/*********************List Method*******************************
 * When a list is received some parameter has been modified. 
 * Automatically it is going to be stored in the "temp" database
 * **************************************************************/
 void List(t_SoundManagerEngine *x, t_symbol *s, int argc, t_atom* argv){
   if (x->flag){
    int ID, index;
    float value;
    ID= (int)atom_getfloatarg(1, argc, argv);
    value = atom_getfloatarg(0, argc, argv);
    index = HashFunction(x, ID);
    //printf("value %f, ID %d, index %d\n", value, ID, index);
    if (index<0) { //Hash function error
    error("ID %d not in the table", (int)ID);
    }
    else { //Hash function success
      x->TempDataBase[index]=value;
    }
    }
  s++;
 }

 /****************************INIT******************************
  * We get a Init message when every object is initialized. The
  * value sent after "init" pd-selector is the object ID.
  **************************************************************/
void Init(t_SoundManagerEngine *x, t_floatarg IDin) {
  int ID, i, index;
  ID = (int)IDin; //get the new element's ID
  printf("Initializing %d\n", ID);
  index=x->InitializedParameters; //get the new element index
  x->vectorID[index]=ID; //save the new ID
  x->InitializedParameters++; //increment the number of stored parameters
}

/*********************Save Method*******************************
 *
 * **************************************************************/
 void Save(t_SoundManagerEngine *x){
 int preset, i;
 preset=x->CurrentPreset;
 snprintf(x->PresetName[preset], NAME_LENGTH, "%s",x->NewName->s_name);
 printf ("Slot %d, Storing %s\n", preset,x->PresetName[preset]);
 for(i=0;i<x->InitializedParameters; i++){
   x->DataBase[preset][i]=x->TempDataBase[i];
 }
}

/*********************Load Method*******************************
 *
 * *************************************************************/
 void Load (t_SoundManagerEngine *x) {
  int preset=(int)x->CurrentPreset;
  int i;
  printf("Loading preset %d: '%s'\n", preset, x->PresetName[preset]);
  t_symbol s;
  t_symbol *a;
  a=&s;
  a->s_name=x->PresetName[preset];
  x->flag=0; //disable recording data
  outlet_symbol(x->SymbolOut, a);
  for(i=0; i<x->InitializedParameters; i++) {
    outlet_float(x->IDout, x->vectorID[i]);
    outlet_float(x->ValueOut, x->DataBase[preset][i]);
    printf("	Outputting %f, %d \n", x->DataBase[preset][i],
	(int)x->vectorID[i]);
  }
  x->flag=1;//enable
 }
 
/*********************Preset Selector Method********************
 * Sending a float selects the presets. The preset value in x is
 * changed. The name stored in the preset's slot is sent, as well
 * as the preset number. 
 * *************************************************************/
 void PresetSelector (t_SoundManagerEngine *x, t_float f){
  x->CurrentPreset=(int)f;
  if(x->CurrentPreset>PRESETS || x->CurrentPreset<0) {
   printf("Preset out of limits\n");
   post("Preset Out of limits");
  }
  else {
    char *name;
    name=x->PresetName[x->CurrentPreset];
    printf("Preset num %d: %s",x->CurrentPreset, name);
    t_symbol s;
    t_symbol *a;
    a=&s;
    a->s_name=name;
//     s->s_name=x->PresetName[x->CurrentPreset];
    outlet_symbol(x->SymbolOut, a); 
    outlet_float(x->PresetNumberOut, (float)x->CurrentPreset);
    x->NewName->s_name=name;
  }
 }
 

 void ShowAll(t_SoundManagerEngine *x) {
    int i , j;
    printf("\n\nShowing all paramters and names\n\n");
    printf("Number of presets %d\n", x->PresetNum);
    for(i=0; i<x->PresetNum; i++) {
     printf("Slot %d: %s", i, x->PresetName[i]);
    }
    
    printf("Number of parameters %d\n", x->ParameterNum);
   
    for (i=0; i<x->PresetNum; i++){
      for (j=0; j<x->ParameterNum; j++) {
	printf("%f ", x->DataBase[i][j]);
      }
      printf("\n");
    }
    printf("\n");
    
    printf("****Data Base\n");
    for(j=0;j<PRESETS; j++) {
      for (i=0; i<x->InitializedParameters; i++){
	printf("%f ", x->DataBase[j][i]);
      }
      printf("\n");
    }
    
    printf("\n****Temp Data Base\n");
    for (i=0; i<x->InitializedParameters; i++){
	printf("%f ", x->TempDataBase[i]);
      
    }
    printf("\nHash Table\n");
    for(i=0; i<x->InitializedParameters; i++){
     printf("%d -> %d\n", i, x->vectorID[i]); 
    }

}

/***************************CONSTRUCTOR**************************/
void *SoundManagerEngine_new(t_symbol *s) {
  t_SoundManagerEngine *x =(t_SoundManagerEngine *)       
  pd_new(SoundManagerEngine_class);
   
  //allocate memory for strings
  int i, j;
  for (i=0; i<PRESETS; i++){
   x->PresetName[i] =malloc(NAME_LENGTH);   
  }
  x->PresetBank[NAME_LENGTH];
  for (i=0; i<PARAMETERS; i++){
    x->TempDataBase[i]=0.0;
    for(j=0;j<PRESETS; j++){
      x->DataBase[j][i]=0;
    }
  }
  x->CurrentPreset=0;
  x->InitializedParameters=0;
  //Inlets    
  x->NewName=&x->s1;
  symbolinlet_new(&x->x_obj, &x->NewName);
    
  //Outlets
  x->ValueOut = outlet_new(&x->x_obj, &s_float); //Value outlet
  x->IDout = outlet_new(&x->x_obj, &s_float);	 //ID outlet
  x->SymbolOut = outlet_new(&x->x_obj, &s_symbol); //Preset's name outlet
  x->PresetNumberOut=outlet_new(&x->x_obj, &s_float);//Bank's name outlet
  
  printf("Initialiation argument %s\n", s->s_name);
 
  x->PresetBank = s->s_name;
  //CreatePresetFile(file, x);
  if (LoadPresetFile(x->PresetBank,x)) {
    printf("File not found, creating blank preset file\n");
    CreatePresetFile(x->PresetBank, x);
    LoadPresetFile(x->PresetBank,x);
  } 
 
  x->NewName->s_name=x->PresetName[0];
  Load(x);
  return (void *)x;
}

void Destructor(t_SoundManagerEngine *x) {
    SavePresetFile(x->PresetBank, x);
    printf("Saving Presets");
}

/***************************SETUP**************************/
void SoundManagerEngine_setup(void) {
SoundManagerEngine_class=class_new(
  gensym("SoundManagerEngine"),
  (t_newmethod)SoundManagerEngine_new,
  (t_method)Destructor,
  sizeof(t_SoundManagerEngine),
  CLASS_DEFAULT,
  A_DEFSYMBOL,
  0);
  
class_addmethod(SoundManagerEngine_class, //belonging class
  (t_method)Save,			//defines the method
  gensym("save"),			//symbolic name
  CLASS_DEFAULT,
  0);

class_addmethod(SoundManagerEngine_class, //belonging class
  (t_method)Init,			//defines the method
  gensym("init"),			//symbolic name
  A_DEFFLOAT,
  0);

class_addmethod(SoundManagerEngine_class,//belonging class
  (t_method)Load,			//defines the method
  gensym("load"),			//symbolic name
  CLASS_DEFAULT,
  0);
// 
//   class_addmethod(SoundManagerEngine_class, 	//belonging class
//   (t_method)LoadPresetsBank,			//defines the method
//   gensym("LoadBank"),			//symbolic name
//   CLASS_DEFAULT,
//   A_DEFSYMBOL,
//   0);
  class_addfloat(SoundManagerEngine_class, PresetSelector);
  class_addbang(SoundManagerEngine_class, ShowAll);
  class_addlist(SoundManagerEngine_class, List);

//class_addlist(SoundManagerEngine_class, NewValue);


}


///////////////////File Manager Functions////////////////////
int CreatePresetFile(char *file, t_SoundManagerEngine *x){
 
  //Prest File strings and variables
  char *PresetNumString="Number of presets:";
  char *ParameterNumString="Number of parameters: ";

  char *defaultName="Empty Preset\n";
  float defaultValue = 0.00;
  FILE *fp;
  int i,j;
  int ret;
  printf("Creating file %s\n", file);
  fp=fopen(file, "w"); //open file in write mode
  if( fp == NULL )
   {
      perror("Error while opening the file.\n");
      return -1;
   }
  //Write preset names haeading
  ret=fprintf(fp,"%s %d\n", PresetNumString, PRESETS);
  
  //write preset names
  for(i=0; i<PRESETS; i++) {
   fprintf(fp, "%s", defaultName);
  }
  
  //write parameters heading
  fprintf(fp,"%s %d\n", ParameterNumString, DEFAULT_PARAMETERS);
  
  //write a single parameter for each preset
  for(i=0; i<PRESETS; i++) {
    for(j=0; j<DEFAULT_PARAMETERS; j++) {
      fprintf(fp,"%f ", defaultValue);
    }
    fprintf(fp, "\n"); 
  }
  fclose(fp);
  x++;
  printf("File created successfully\n");
  return 0;
}


int LoadPresetFile(char *file, t_SoundManagerEngine *x) {
  FILE *fp;
  int i,j, charCount=0, ret, num;
  int presets, parameters;
  char junk[NAME_LENGTH], inChar=0, ch;
  char buffer[NAME_LENGTH]="";
  float inFloat;
  
  printf("Loading file %s...\n", file);
  fp=fopen(file, "r");
    if( fp == NULL ) {
      perror("Error while opening the file");
      return -1;
   }
   //read the number of presets
   ret=fscanf(fp,"%s %s %s %d%c",junk,junk,junk,&presets, &inChar); 
   x->PresetNum=presets;
   printf("Presets %d\n", x->PresetNum);
   inChar=100;
   charCount=0;
   //read all preset names
   for(i=0; i<presets; i++) {
    ret=fscanf(fp, "%c", &inChar);
     while(inChar!='\n'){
      buffer[charCount]=inChar;
      ret=fscanf(fp, "%c", &inChar);
      charCount++;
     }    
    snprintf(x->PresetName[i], NAME_LENGTH, "%s", buffer);
    for (j=0; j<NAME_LENGTH; j++) buffer[j]=0; //empty the buffer
    charCount=0;
    inChar=0;
    printf("%d\n", i);
   }
   printf("Sortim dels noms");
   
   //getting the number of parameters
   ret=fscanf(fp,"%s %s %s %d%c",junk,junk,junk, &parameters,junk);
   x->ParameterNum=parameters;
   printf("parameters %d\n", x->ParameterNum);
  
   for (i=0; i<presets;i++){
     for(j=0; j<parameters; j++){
      ret=fscanf(fp,"%f %c", &inFloat, &inChar);
      x->DataBase[i][j]=inFloat;
    }
    ret=fscanf(fp,"%c", &inChar);
   }
     printf("file %s read succesfully\n", file);

   return 0;
}


int SavePresetFile(char *file, t_SoundManagerEngine *x){
  FILE *fp;
  int i,j,ret;
  
  char *PresetNumString="Number of presets:";
  char *ParameterNumString="Number of parameters: ";
  
  fp=fopen(file, "w"); //open file in write mode
  if( fp == NULL )
   {
      perror("Error while opening the file.\n");
      return -1;
   }
  //Write preset names haeading
  ret=fprintf(fp,"%s %d\n", PresetNumString, PRESETS);
  
  //write preset names
  for(i=0; i<PRESETS; i++) {
   ret=fprintf(fp, "%s\n", x->PresetName[i]);
  }
  //write parameters heading
  ret=fprintf(fp,"%s %d\n", ParameterNumString, x->InitializedParameters);
  
  //write a single parameter for each preset
  for(i=0; i<PRESETS; i++) {
    for(j=0; j<x->InitializedParameters; j++) {
      ret=fprintf(fp,"%f ", x->DataBase[i][j]);
    }
    ret=fprintf(fp, "\n"); 
  }
  fclose(fp);
  x++;
  return 0;
}

int HashFunction(t_SoundManagerEngine *x, int input) {
 t_int i, result=-1;
 for (i=0; i<x->InitializedParameters; i++){
  if (x->vectorID[i]==input) {
    result=i;
    break;
  }
 }
 return result;
}