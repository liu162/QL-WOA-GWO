clear
close all;
clc

SearchAgents_no=30; % Number of search agents
Function_name='F1';%

Max_iteration=1500; % Maximum numbef of iterations

for j=1:10
% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);

[QL_Best_score,QL_Best_pos,QL_WOA_GWO_cg_curve]=QL_WOA_GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
QL_WOA_GWO_result(j,:)=QL_WOA_GWO_cg_curve;

end


 QL_WOA_GWO=mean(QL_WOA_GWO_result);

semilogy(QL_WOA_GWO,'r','linewidth',1,'MarkerSize',8);

  title('Objective space')
  xlabel('Iteration');
  ylabel('Best Score');

axis tight
grid on
box on
legend('QL-WOA-GWO')
