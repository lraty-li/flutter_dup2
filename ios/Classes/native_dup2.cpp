#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
// #include <signal.h>

extern "C" __attribute__((visibility("default"))) __attribute__((used))

int runDup2(char *str,int fd)
{

    int filefd = open(str, O_RDWR | O_TRUNC | O_CREAT, S_IRWXU);
    if (filefd < 0)
    {
        printf("create file failed");
        return filefd;
        // exit(-1);
    }
    // dup2(filefd, 0);
    // dup2(filefd, 1);
    // dup2(filefd, 2);

    //android fd=3
    dup2(filefd, fd);
    return filefd;
}