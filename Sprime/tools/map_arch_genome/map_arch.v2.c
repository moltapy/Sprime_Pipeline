#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<zlib.h>

void print_help(char *argv[])
{
//--deepth :add read DP\n
fprintf(stderr, "\
Usage: %s \n \
--kp/--rm/--kpall :bed file for keep/romove/no-use\n \
--sep sep :define the separator in the outpout file \n \
--mskbed  maskfile :maskfile, only one allowed as the input \n \
--vcf vcffile :archaic genome in VCF, one individuals \n \
--score scorefile : scorefile from Sprime \n \
--tag reftag :tag for the added column\n", argv[0]);
}

int main(int arg, char *argv[])
{
char mskfile[1024], vcffile[1024], scorefile[1024], cmd[10240], reftag[32], sep[32], sp;
int i, j, k, kp, dp;
sprintf(reftag, "MATCHING");
sprintf(mskfile, "NULL");
sp='\t';
dp=0;
if(arg == 1){print_help(argv);exit(-1);}

i=1;
while(i<arg)
{
//fprintf(stderr, "%s\n", argv[i]);
if(strcmp(argv[i], "--mskbed")==0){sprintf(mskfile, "%s", argv[i+1]);i=i+2;}
else if(strcmp(argv[i], "--vcf")==0){sprintf(vcffile, "%s", argv[i+1]);i=i+2;}
else if(strcmp(argv[i], "--score")==0){sprintf(scorefile, "%s", argv[i+1]);i=i+2;}
else if(strcmp(argv[i], "--tag")==0){sprintf(reftag, "%s", argv[i+1]);i=i+2;}
else if(strcmp(argv[i], "--sep")==0){sprintf(sep, "%s", argv[i+1]);i=i+2;}
else if(strcmp(argv[i], "--kp")==0){kp=1;i=i+1;}
else if(strcmp(argv[i], "--rm")==0){kp=0;i=i+1;}
else if(strcmp(argv[i], "--kpall")==0){kp=2;i=i+1;}
else if(strcmp(argv[i], "--deepth")==0){dp=1;i=i+1;}
else {
fprintf(stderr, "wrong option: %s\n", argv[i]);
print_help(argv);
exit(-1);
}
}

if(kp!=2&&strcmp(mskfile, "NULL")==0){fprintf(stderr, "Please check mask file!\n");return -1;}

//fprintf(stderr, "%s\n", sep);
//for(i=0;i<strlen(sep);i++)fprintf(stderr, "%c*%d",sep[i], i);
if(strcmp(sep, "\\t")==0)sp='\t';
if(strcmp(sep, " ")==0)sp=' ';

FILE *ifp;
gzFile gzfp;
char buffer[10240], str[1024], tmpc;
int pos;
int start, end, L_max=0;

//maximum length from score file
ifp=fopen(scorefile, "r");
fgets(buffer, 10240, ifp);
while(fgets(buffer, 10240, ifp)!=NULL){
sscanf(buffer, "%*s %d", &pos);
if(L_max<=pos)L_max=pos;
}
fclose(ifp);
if(L_max == 0){
fprintf(stderr, "check the file %s\n", scorefile);
exit(-1);
}
fprintf(stderr, "MAX LENGTH: %d\t", L_max);

//initiate the database of site information.
////data[,0:2]=mask, allele-1, allele-2
////deepth
char **data;
int *deepth;
data=(char **)malloc((L_max+1)*sizeof(char *));
deepth=(int *)malloc((L_max+1)*sizeof(int));
for(i=0;i<(L_max+1);i++){
data[i]=(char *)malloc(3*sizeof(char));
if(kp==1)data[i][0]='0';
if(kp==0||kp==2)data[i][0]='1';
deepth[i]=-1;
}

if(kp==1||kp==0){
//fill the mask, 
gzfp=gzopen(mskfile, "r");
if(gzfp == Z_NULL){
fprintf(stderr, "Error: check the file %s\n", mskfile);
exit(-1);
}
while(gzgets(gzfp, buffer, 1024)!=NULL){
sscanf(buffer, "%s %d %d", str, &start, &end);
for(i=start+1;i<=end;i++){
if(i>L_max)break;
if(kp==1)data[i][0]='1';
if(kp==0)data[i][0]='0';
}
}
gzclose(gzfp);
}
//fprintf(stderr, "INITIATION COMPLETED!\n");

//fill the diploid state
char ref[128], alt[128], DP[128], gt[128], *s;
gzfp=gzopen(vcffile, "r");
if(gzfp == Z_NULL){
fprintf(stderr, "Error: check the file %s\n", vcffile);
exit(-1);
}
while(gzgets(gzfp, buffer, 10240)!=NULL){if(buffer[2]!='#');break;}
while(gzgets(gzfp, buffer, 10240)!=NULL){
sscanf(buffer, "%*s %d %*s %s %s %*s %*s %s %*s %s", &pos, ref, alt, DP, gt);
//fprintf(stderr, "%d %s %s %s %s\n",pos, ref, alt, DP, gt);
if(pos<=L_max){
if(strlen(ref)<2&&strlen(alt)<2){
if(gt[0]=='0')data[pos][1]=ref[0];
if(gt[0]=='1')data[pos][1]=alt[0];
if(gt[2]=='0')data[pos][2]=ref[0];
if(gt[2]=='1')data[pos][2]=alt[0];
s=DP;
s+=3;
//printf("%s %s %d\n", DP, s, atoi(s));
if(atoi(s)>=1)deepth[pos]=atoi(s);
else deepth[pos]=1;
}
}
}
gzclose(gzfp);
//fprintf(stderr, "DATA BASE COMPLETED!\n");
//return -1;
//input the score file
char SNP[2];
ifp=fopen(scorefile, "r");
fgets(buffer, 10240, ifp);
for(i=0;i<(strlen(buffer)-1);i++)printf("%c", buffer[i]);
printf("%c%s", sp,reftag);
if(dp==1)printf("%c%s_DP",sp, reftag);
printf("\n");
while(fgets(buffer, 10240, ifp)!=NULL){
sscanf(buffer, "%*s %d %*s %c %c %*d %d", &pos, &SNP[0], &SNP[1], &k);
for(i=0;i<(strlen(buffer)-1);i++)printf("%c", buffer[i]);
if(data[pos][0]=='0'||deepth[pos]<0){
printf("%cnotcomp",sp);
if(dp==1)printf("%c%d",sp, deepth[pos]);
printf("\n");
}
else {
if(SNP[k]==data[pos][1]||SNP[k]==data[pos][2])printf("%cmatch",sp);
else printf("%cmismatch",sp);
if(dp==1)printf("%c%d", sp, deepth[pos]);
printf("\n");
}

}
fclose(ifp);


fprintf(stderr, "%s COMPLETED!\n", reftag);
return 0;
}
