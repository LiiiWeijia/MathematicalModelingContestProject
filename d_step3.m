%% 运动片段提取
clc, clear, close all
%% 加载数据
load('gooddata.mat');
%% 判断是否为怠速情况
% [m,n]=size(gooddata);
% sumidle=0;
% for i=1:m
%     if gooddata(i,2)<10
%         idle1(i)=1;
%         sumidle=sumidle+1;
%     else
%         idle1(i)=0;
%     end
% end
% Idle1=idle1';
% clear i m n idle1;
%% 判断怠速、加速、减速、匀速情况
sportaccle=[0;(diff(gooddata(:,2)))/3.6];
[m,n]=size(gooddata);
sumidle=0;
sumacce=0;
sumslow=0;
sumuniform=0;
for i=1:m
    if gooddata(i,2)<10
        Idle1(i,1)=1;
        Accle(i,1)=0;
        Slow(i,1)=0;
        Unifor(i,1)=0;
        sumidle=sumidle+1;
    else
        Idle1(i,1)=0;
        if sportaccle(i)>0.1
            Accle(i,1)=1;
            Slow(i,1)=0;
            Unifor(i,1)=0;
            sumacce=sumacce+1;
        elseif sportaccle(i)<-0.1
            Slow(i,1)=1;
            Accle(i,1)=0;
            Unifor(i,1)=0;
            sumslow=sumslow+1;
        else
            Unifor(i,1)=1;
            Accle(i,1)=0;
            Slow(i,1)=0;
            sumuniform=sumuniform+1;
        end
    end
end
clear i m n;
%% 运动片段划分
[m,n]=size(Idle1);
sunsport=0;
ii=1;
for i=1:m
    if Idle1(i,1)==0&&Idle1(i+1,1)==1
        Sport(i,1)=ii;
        ii=ii+1;
    else
        Sport(i,1)=ii;
    end
end
 clear i m n;

%% 统计运动片段划分情况
% sportnum=tabulate(Sport);
% x=sportnum(:,1);
% y=sportnum(:,2);
% bar(x,y)
% plot(sportnum(:,2),sportnum(:,3));
% ssnum=tabulate(sportnum(:,2));
% bar(ssnum(:,3));
 %% 运动片段指标计算
sportnum=tabulate(Sport);
sportid=sportnum(:,1);
sportv=gooddata(:,2);
stratindex=cumsum(sportnum(:,2))-sportnum(:,2)+1;
endindex=cumsum(sportnum(:,2));
sportaccle=[0;(diff(sportv))/3.6];
for i=1:ii
    staytime(i,1)=sportnum(i,2);
    distan(i,1)=((mean(sportv(stratindex(i):endindex(i),1)))/3.6)*staytime(i);
    deltv(i,1)=max(sportv(stratindex(i):endindex(i),1))-min(sportv(stratindex(i):endindex(i),1));
    idletime(i,1)=sum(Idle1(stratindex(i):endindex(i),1));
    accetime(i,1)=sum(Accle(stratindex(i):endindex(i),1));
    slowtime(i,1)=sum(Slow(stratindex(i):endindex(i),1));
    unifortime(i,1)=sum(Unifor(stratindex(i):endindex(i),1));
    vmax(i,1)=max(sportv(stratindex(i):endindex(i),1));
    vmean(i,1)=mean(sportv(stratindex(i):endindex(i),1));
    dvmean(i,1)=mean(sportv(stratindex(i)+idletime(i,1):endindex(i),1));
    vstd(i,1)=std(sportv(stratindex(i):endindex(i),1));
    accmax(i,1)=max(sportaccle(stratindex(i):endindex(i),1));
    %平均加速度：该片段内汽车在加速状态（加速度大于0.1m/s2的连续过程）下各单位时间（秒）加速度的算术平均值
    am=[];
    for iiii=stratindex(i):endindex(i)
        accvnum=0;
        slowaccnum=0;
        accv=[];
        slowaccv=[];
        if Accle(iiii)==1
            accv(accvnum+1)=sportaccle(iiii,1);
            accvnum=accvnum+1;
        elseif Slow(iiii)==1
            slowaccv(slowaccnum+1)=sportaccle(iiii,1);
            slowaccnum=slowaccnum+1;
        else 
            continue;
        end
    end
    if isempty(slowaccv)==1
        slowaccv=0;
    elseif isempty(accv)==1
        accv=0;
    end
    avacc(i,1)=mean(accv);
    slowmax(i,1)=abs(min(slowaccv));
    slowmean(i,1)=abs(mean(slowaccv));
    acclestd(i,1)=std(accv);
    Pidle(i,1)=idletime(i,1)/staytime(i,1);
    Paccle(i,1)=accetime(i,1)/staytime(i,1);
    Pslow(i,1)=slowtime(i,1)/staytime(i,1);
    Punifor(i,1)=unifortime(i,1)/staytime(i,1);
end
sportindex=[sportid,staytime,distan,deltv,idletime,accetime,slowtime,unifortime,vmax,vmean,dvmean,vstd,accmax,avacc,slowmax,slowmean,acclestd,Pidle,Paccle,Pslow,Punifor];
clear i accvnum  slowaccnum iiii accv slowaccv;
 %% 运动片段标签导出
% sportdata=[gooddata,Sport];
% xlswrite('Step2_data.xlsx', sportdata, 'sheet1');
% xlswrite('Step2_data2.xlsx', sportnum, 'sheet1');
% xlswrite('Step2_data3.xlsx', ssnum, 'sheet1');
xlswrite('sportindex1.xlsx', sportindex, 'sheet1');