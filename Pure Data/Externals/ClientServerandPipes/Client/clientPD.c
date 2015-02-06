#include "m_pd.h"
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <fcntl.h>

#define PORT 3333


//const char *path = "/home/enoc/projecte/Bck/ComTest";
const char *path = "/home/enoc/projecte/Bck/a";
const char *host = "127.0.0.1";



/***************************CLASS DECLARATION***************************/

static t_class *clientPD_class; //create clientPD class

/***************************DATA SPACE***************************/
//variables of the class
typedef struct _clientPD {
	t_object x_obj; //object properties for PD environment
	t_int sockfd;	//channel to read
	t_outlet *f_out; //output
} 
t_clientPD;


/***************************METHODS***************************/
void clientPD_bang (t_clientPD *x) {
	//post("Bang received");
	
	int channel, data, ret;
	data=0;
	ret=write(x->sockfd, &data, sizeof(int));
	if (ret<0) post("Error requesting number");
	else printf("Request sent\n");
	ret = read (x->sockfd, &data, sizeof(int));
	if (ret<0) post("Nothing to read error!");
	else {
	  outlet_float(x->f_out, data); //send the clientPD level
	  printf("received %d\n", data);
	}
	
}

/***************************CONSTRUCTOR***************************/

void *clientPD_new(t_symbol *s, int argc, t_atom *argv) {
 
  //---------STARTING SERVER CONNECTION-------//
  int sockfd, portno, n;
  struct sockaddr_in serv_addr;
  struct hostent *server;
  printf("Starting connection...\n");

  //creating the socket
  sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if (sockfd < 0) printf("ERROR opening socket");
  else printf("Socket opened\n");
  server = gethostbyname(host);
  if (server==NULL) printf("no such host\n");
  else printf("Server host found\n");
  
  portno=PORT;
    
  bzero((char *) &serv_addr, sizeof(serv_addr));
  serv_addr.sin_family = AF_INET;
  bcopy((char *)server->h_addr, 
	(char *)&serv_addr.sin_addr.s_addr,
	server->h_length);
  serv_addr.sin_port = htons(portno);
  
  
  if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) 
        printf("ERROR connecting\n");
   else printf("Socket connection succesful\n");
  
  printf("\n****Fins aquí bé\n");
  
    /*int sockfd, portno, n;


    printf("Starting connection..."\n);
    portno = PORT;
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    //server = gethostbyname(argv[1]);
    server = gethostbyname(host);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
   else printf("Socket connection succesful");
  

  */
  
  
  t_clientPD *x = (t_clientPD *)pd_new(clientPD_class);
  x->sockfd=sockfd;
  x->f_out =  outlet_new(&x-> x_obj, &s_float);
  return (void *)x;
}

/***************************SETUP***************************/

void clientPD_setup(void) {
	clientPD_class=class_new	//Create the new class
		(gensym("clientPD"),	//symbolic name of the class
		(t_newmethod)clientPD_new,//constructor (called when PD 
		0,			//destructor(never in this case)
		sizeof(t_clientPD),	//logic space of the object
		CLASS_DEFAULT, 		//graphical representation of the object
		0, 		//Variable number of inputs
		0); 			//0 indicate the ending of the list 

	class_addbang(		//new method 
		clientPD_class, 	//belonging class
		clientPD_bang); 	//adding the bang method

	//class_sethelpsymbol(clientPD_class, gensym("help-clientPD")); //help 
}

