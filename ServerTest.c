/*
** listener.c -- a datagram sockets "server" demo
** Modified to be continuous by johnboiles
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


#define MYPORT 4950    // the port users will be connecting to

#define MAXBUFLEN 100

#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */

/*
 * 'open_port()' - Open serial port 1.
 *
 * Returns the file descriptor on success or -1 on error.
 */

int
open_port(void)
{
    int fd; /* File descriptor for the port */
    struct termios options;

    fd = open("/dev/tts/1", O_RDWR | O_NOCTTY | O_NDELAY);
    if (fd == -1)
    {
           /*
        * Could not open the port.
        */

        perror("open_port: Unable to open /dev/ttyS0 - ");
    } else
        fcntl(fd, F_SETFL, 0);

    
    /*
     * Get the current options for the port...
     */
    tcgetattr(fd, &options);

    /*
     * Set the baud rates to 19200...
     */
    cfsetispeed(&options, B38400);
    cfsetospeed(&options, B38400);

    /*
     * Enable the receiver and set local mode...
     */

    options.c_cflag |= (CLOCAL | CREAD);

    /*
     * Set the new options for the port...
     */

    tcsetattr(fd, TCSANOW, &options);


    return (fd);
}



int main(void)
{
    int sockfd;
    struct sockaddr_in my_addr;    // my address information
    struct sockaddr_in their_addr; // connector's address information
    socklen_t addr_len;
    int numbytes;
    char buf[MAXBUFLEN];
    int yes=1;
    int fd;	
	int xtemp;
	int ytemp;

    printf("\n");  
      
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
        perror("socket");
        exit(1);
    }

    my_addr.sin_family = AF_INET;         // host byte order
    my_addr.sin_port = htons(MYPORT);     // short, network byte order
    my_addr.sin_addr.s_addr = INADDR_ANY; // automatically fill with my IP
    memset(my_addr.sin_zero, '\0', sizeof my_addr.sin_zero);

    if (bind(sockfd, (struct sockaddr *)&my_addr, sizeof my_addr) == -1) 
    {
        perror("bind");
        exit(1);
    }


    addr_len = sizeof their_addr;

    //Serial port code

	fd=open_port();
    
    while(1){    
    
        if ((numbytes = recvfrom(sockfd, buf, MAXBUFLEN-1 , 0,(struct sockaddr *)&their_addr, &addr_len)) == -1) {
            perror("recvfrom");
            exit(1);
        }

        //printf("got packet from %s\n",inet_ntoa(their_addr.sin_addr));
        //printf("packet is %d bytes long\n",numbytes);
        //buf[numbytes] = '\0';
        //printf("packet contains \"%s\"\n",buf);   

        //forward the package out the serial port
        write(fd, buf, numbytes);
        xtemp = (unsigned char) buf[1];
        ytemp = (unsigned char) buf[3];
        
        printf("Command: %c %d %c %d\n",buf[0],xtemp,buf[2],ytemp);
    }
    
    close(sockfd);

    return 0;
}

