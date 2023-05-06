#include <stdio.h>
#include <ctype.h>

int main(){
    int age;
    printf("\nEnter your age: ");
    scanf("%d", &age);
    if(age >= 18){
        printf("You're now signed up!");
    }
    else if(age < 0){
        printf("You haven't been born yet");
    }
    else{
        printf("you're too young to sign up");
    }
    return 127;
}