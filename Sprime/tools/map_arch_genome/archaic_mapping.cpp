//
// Created by 22634 on 2024/4/16.
//
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <zlib.h>
#include <cstring>

using namespace std;

//help module
void print_help(const std::string& programName)
{
    std::cerr << "Usage: " << programName << "\n"
              << "--kp/--rm/--kpall : bed file for keep/remove/not_use\n"
              << "--sep sep : define the separator in the output file\n"
              << "--mskbed mask_file : mask_file, only one allowed as the input\n"
              << "--vcf vcf_file : archaic genome in VCF, one individuals\n"
              << "--score score_file : score_file from Sprime\n"
              << "--tag ref_tag : tag for the added column\n"
              << "--depth read depth : add read depth for match\n";
}


int main(int argc,char *argv[])
{
    vector<std::string> arguments(argv, argv + argc);
    if (arguments.size() == 1) {
        print_help(arguments[0]);
        exit(-1);
    }
    string mask_file="NULL",vcf_file,score_file,cmd,ref_tag="MATCHING",sep;
    char ofs='\t';
    int i=1,j,k,bed_options,depth_options=0,archaic_pos;
    const int BUFFER_SIZE=102401;
    gzFile mask_gz,archaic_gz;
    while(i<argc){
        if(strcmp(argv[i],"--mskbed")==0){mask_file=argv[i+1];i+=2;}
        else if(strcmp(argv[i],"--vcf")==0){vcf_file=argv[i+1];i+=2;}
        else if(strcmp(argv[i],"--score")==0){score_file=argv[i+1];i+=2;}
        else if(strcmp(argv[i],"--tag")==0){ref_tag=argv[i+1];i+=2;}
        else if(strcmp(argv[i],"--sep")==0){sep=argv[i+1];i+=2;}
        else if(strcmp(argv[i],"--kp")==0) {bed_options=1;i+=1;}
        else if(strcmp(argv[i],"--rm")==0) {bed_options=0;i+=1;}
        else if(strcmp(argv[i],"--kpall")==0) {bed_options=2;i+=1;}
        else if(strcmp(argv[i],"--depth")==0) {depth_options=1;i+=1;}
        else
        {
            cerr << "wrong option" << argv[i] << endl;
            print_help(argv[i]);
            return -1;
        }
    }
    if(bed_options!=2 && strcmp(mask_file.c_str(), "NULL")==0){
        cerr << "Mask file is NuLL,Please check!" << endl;
        return -1;
    }
    if(sep=="\\t") ofs = '\t';
    if(sep==" ") ofs = ' ';
    ifstream infile(score_file);
    int pos,chr;
    char buffer[BUFFER_SIZE];
    int start_site,end_site,Length_Max=0;
    if (!infile.is_open()){
        cerr << "Unable to open score_file" << score_file << endl;
        return -1;
    }
    infile.getline(buffer,BUFFER_SIZE);
    while(infile.getline(buffer,BUFFER_SIZE)){
        stringstream iss(buffer);
        iss >> chr;
        iss >> pos;
        if (iss.fail()) {
            cerr << "Failed to parse pos" << endl;
            // 可以根据需要采取适当的错误处理措施
        }
        if(Length_Max<=pos) Length_Max=pos;
    }
    if(Length_Max == 0){
        cerr << "The score_file chromosome Length equals 0, may missing" << score_file << endl;
        return -1;
    }
    infile.close();

    cerr << "Max_Length:"<<Length_Max<<endl;



    //构建数据框，后续重构成一块
    vector<string> data(Length_Max+1);
    vector<int> depth(Length_Max+1,-1);
    for(int i = 0; i<=Length_Max;++i){
        data[i].resize(3);
        if(bed_options==1) data[i][0] = '0';
        if(bed_options==0 || bed_options==2) data[i][0] = '1';
    }
    if(bed_options == 1 || bed_options == 0){
        mask_gz= gzopen(mask_file.c_str(),"rb");
        if (mask_gz == Z_NULL){
            cerr << "mask file cannot open, may missing" << mask_file.c_str()<<endl;
            return -1;
        }
    }
    string str;
    while(gzgets(mask_gz,buffer,BUFFER_SIZE)!=NULL){
        stringstream iss(buffer);
        iss >> str >> start_site >> end_site;
        for (int i = start_site+1;i<=end_site;i++){
            if(i>Length_Max) break;
            if (bed_options==1) data[i][0] = '1';
            else if (bed_options==0) data[i][0] ='0';
        }
    }
    gzclose(mask_gz);



    string ref,alt,DP,gt;
    string rm_1,rm_2,rm_3,rm_4,rm_5;
    archaic_gz = gzopen(vcf_file.c_str(),"rb");
    if (archaic_gz == Z_NULL){
        cerr << "archaic VCF file cannot open, may missing" << vcf_file.c_str()<<endl;
        return -1;
    }
    while(gzgets(archaic_gz,buffer,BUFFER_SIZE)!=NULL){if(buffer[1]!='#') break;}
    //check##andremove
    while(gzgets(archaic_gz,buffer,BUFFER_SIZE)!=NULL){
        stringstream iss(buffer);
        iss>>rm_1>>archaic_pos>>rm_2>>ref>>alt>>rm_3>>rm_4>>DP>>rm_5>>gt;
        if (archaic_pos<=Length_Max){
            if(ref.length()<2 && alt.length()<2){
                if(gt[0]=='0') data[archaic_pos][1] = ref[0];
                if(gt[0]=='1') data[archaic_pos][1] = alt[0];
                if(gt[2]=='0') data[archaic_pos][2] = ref[0];
                if(gt[2]=='1') data[archaic_pos][2] = alt[0];
                size_t found = DP.find("DP=");
                if(found != string::npos){
                    DP=DP.substr(found+3);
                    depth[archaic_pos]=atoi(DP.c_str());
                }
                else depth[archaic_pos]=1;
            }
        }

    }
    gzclose(archaic_gz);


    char SNP[2];
    ifstream inscore(score_file);
    inscore.getline(buffer,BUFFER_SIZE);
    for(int i=0;i<(strlen(buffer));i++) cout<<buffer[i];
    cout<<ofs<<ref_tag;
    if(depth_options==1) cout << ofs<<ref_tag<<"_DP";
    cout<<endl;
    while(inscore.getline(buffer,BUFFER_SIZE)){
        sscanf(buffer,"%*s %d %*s %c %c %*d %d",&pos,&SNP[0],&SNP[1],&k);
        for(int i=0;i<(strlen(buffer));i++) cout<<buffer[i];
        if(data[pos][0]=='0' || depth[pos]<0){
            cout << ofs<<"notcomp";
            if(depth_options==1) cout <<ofs<<depth[pos];
            cout<<endl;
        }
        else{
            //cerr<<data[pos][1]<<"\t"<<data[pos][2]<<"\t"<<SNP[k]<<endl;
            if(SNP[k]==data[pos][1] || SNP[k]==data[pos][2]) cout << ofs<<"match";
            else cout << ofs<<"mismatch";
            if(depth_options==1) cout <<ofs<<depth[pos];
            cout<<endl;
        }
    }
    inscore.close();

    cerr << ref_tag<<"Completed!"<<endl;
    return 0;

}
