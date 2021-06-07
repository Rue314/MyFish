%% �������ļ�����������Ҫ�õ�ǰ����������ɵ������ļ�
clc
clear all
close all

%% ��ȡ����
% load EVdata.mat
% load data.mat

global EVLoad BLoad WTP EV
global EPrice
global EVnum

EVnum = 1000;%EV����
EV0
data
load EVdata.mat
load data.mat
BLoad = Load(:,2)';
[EPrice,PriceT] = EPriceCAL(WTP(:,2));%���Ƿ��Ӱ��ĵ��
HighPriceTime = [];MediumPriceTime = [];LowPriceTime = [];

for i = 1 : length(PriceT)
    if PriceT(i) == 1
        HighPriceTime = [HighPriceTime,i];
    end
    if PriceT(i) == 2
        MediumPriceTime = [MediumPriceTime,i];
    end
    if PriceT(i) == 3
        LowPriceTime = [LowPriceTime,i];
    end
end
%% PSO��������
% Problem preparation 
problem.nVar = EVnum;
problem.ub = ones(1,EVnum)*30;% Upper boundary
problem.lb = EV(:,1)';% Lower boundary
problem.fobj = @fun;

% PSO parameters 
noP = 10;
maxIter = 1000;
visFlag = 0; % set this to 0 if you do not want visualization

RunNo  = 30; 
BestSolutions_PSO = zeros(1 , RunNo);


%% PSO�Ż�
[GBEST , cgcurve] = PSO( noP , maxIter, problem , visFlag ) ;

% % % % [BestSol,BestCost] = pso(nVar,VarMin,VarMax,...
% % % %     MaxIt,nPop,w,wdamp,c1,c2,@fun);
%% ����ͼ
figure
plot(cgcurve,'-r','Linewidth',1.5)

title('PSO����ͼ');
xlabel('��������');
ylabel('Ŀ�꺯��');



%% �Ż����չʾ---�������µ�
disp('���綯�������ȳ��ʱ��㣺')
round(GBEST.X)

disp('���ŵ綯�������Ȳ��Ե�Ŀ�꺯��')
GBEST.O

[~,deltaP,ChargeCost,PLD] = fun(GBEST.X);
disp('���ŵ綯�������Ȳ��Եķ�Ȳ�')
deltaP

disp('���ŵ綯����������')
ChargeCost

%% ��ͼ���õ��綯�����Ż�ǰ���ܵĸ�������
plot(PLD(1,:),'-rs','linewidth',2);
title('�Ż��綯����������ǰ����ܸ���');
xlabel('ʱ��/h');
ylabel('��������/kW');
hold on 


PLD0 = BLoad + EVLoad;
plot(PLD0(1,:),'-gs','linewidth',2);
% title('�Ż��綯����������ǰ����ܸ���');
% xlabel('ʱ��/h');
% ylabel('��������/kW');
legend('�Ż��󸺺�����','�Ż�ǰ��������')

%% ����չʾ
disp(['�ߵ��ʱ��Σ� ',num2str(HighPriceTime)])

disp(['ƽ���ʱ��Σ� ',num2str(MediumPriceTime)])

disp(['�͵��ʱ��Σ� ',num2str(LowPriceTime)])

PLD5 = PLD;
save loaddata1000 PLD5