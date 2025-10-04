
% 
function [Leader_score,Leader_pos,Convergence_curve]=QL_WOA_GWO(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

% initialize position vector and score for the leader
Leader_pos=zeros(1,dim);
Leader_score=inf; %change this to -inf for maximization problems
%Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb);


N=SearchAgents_no;
% initialize the params of Q-Learning
action_num = 3;
Reward_table = zeros(action_num, action_num, N);
Q_table = zeros(action_num, action_num, N);
cur_state = randi(action_num);

gamma = 0.5;
lambda_initial = 0.9;
lambda_final = 0.1;

Convergence_curve=zeros(1,Max_iter);

t=0;% Loop counter

% Main loop
while t<Max_iter
    for i=1:size(Positions,1)
        
        % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        % Calculate objective function for each search agent
        fitness(i)=fobj(Positions(i,:));
        
        % Update the leader
        if fitness(i)<Leader_score % Change this to > for maximization problem
            Leader_score=fitness(i); % Update alpha
            Leader_pos=Positions(i,:);
        end
        
    end
    [~,sort_index]=sort(fitness); % 
    Alpha_pos=Positions(sort_index(1),:); % 确定父代Alpha狼
    Beta_pos=Positions(sort_index(2),:); % 确定父代Beta狼
    Delta_pos=Positions(sort_index(3),:); % 确定父代Delta狼


    
    a=2-t*((2)/Max_iter); % a decreases linearly 
    
    % a2 linearly dicreases from -1 to -2 to calculate t 
    a2=-1+t*((-1)/Max_iter);
    w2=1*(rand-0.5);
    % Update the Position of search agents 
    for i=1:size(Positions,1)
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        
        A=2*a*r1-a;  % Eq. (2.3) in the paper
        C=2*r2;      % Eq. (2.4) in the paper
        
        
        b=1;               %  parameters 
        l=(a2-1)*rand+1;   %  parameters 
        
        p = rand();        % p 
        Position=Positions;
        for j=1:size(Positions,2)
            if(Q_table(cur_state, 1, i) >= Q_table(cur_state, 2, i) && Q_table(cur_state, 1, i) >= Q_table(cur_state, 3, i))
                action = 1;
                % Exploration

                rand_leader_index = floor(SearchAgents_no*rand()+1);
                X_rand = Positions(rand_leader_index, :);
                D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % 
                Position(i,j)=X_rand(j)-A*D_X_rand;      % 

            elseif(Q_table(cur_state, 2, i) >= Q_table(cur_state, 1, i) && Q_table(cur_state, 2, i) >= Q_table(cur_state, 3, i))
                action = 2;
                
                D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); % 
                Position(i,j)=Leader_pos(j)-A*D_Leader;      % 

            else
                action = 3;
                % Exploitation
                %Update the position of the current search by 
                distance2Leader=abs(Leader_pos(j)-Positions(i,j));
                % 
                Position(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(j);
            end
            
        end
        

        Flag4lb = Position(i,:) < lb;
        Flag4ub = Position(i,:) > ub;
        Position(i,:) = sort(Position(i,:) .* (~(Flag4ub + Flag4lb)) + ub .* Flag4ub + lb .* Flag4lb);
        new_fitness = fobj(Position(i,:));
        for j=1:size(Positions,2)          
            if action == 1
                r1=rand(); % r1 is a random number in [0,1]
                r2=rand(); % r2 is a random number in [0,1]
                
                A1=2*a*r1-a; % Equation (3.3)
                C1=2*r2; % Equation (3.4)
                D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j)); % Equation 
                X=Alpha_pos(j).*w2-A1*D_alpha; % Equation 
            elseif action == 2

                r1=rand();
                r2=rand();
                
                A2=2*a*r1-a; % Equation 
                C2=2*r2; % Equation 
                
                D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); % Equation
                X=Beta_pos(j).*w2-A2*D_beta; % Equation    
            else
                r1=rand();
                r2=rand(); 
                
                A3=2*a*r1-a; % Equation
                C3=2*r2; % Equation
                
                D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); % Equation
                X=Delta_pos(j).*w2-A3*D_delta; % Equation             
            end     
        end

        Flag4lb = X < lb;
        Flag4ub = X > ub;
        X = sort((X .* (~(Flag4ub + Flag4lb)) + ub .* Flag4ub + lb .* Flag4lb));
        mutation_fit = fobj(X);
        
        if mutation_fit < new_fitness
            new_fitness = mutation_fit;
            Position(i,:) = X;
        end

        if new_fitness < fitness(i)
            Positions(i, :) = Position(i,:);
            fitness(i) = new_fitness;
            Reward_table(cur_state, action, i) = 1;
        else
            Reward_table(cur_state, action, i) = -1;
        end
        

        r =  Reward_table(cur_state, action, i);
        maxQ = max(Q_table(action, :, i));
        lambda = (lambda_initial + lambda_final) / 2 - (lambda_initial - lambda_final) / 2 * cos(pi * (1 - t / Max_iter));
        Q_table(cur_state, action, i) = Q_table(cur_state, action, i) + lambda * (r + gamma * maxQ - Q_table(cur_state, action, i));
        cur_state = action;

    end
    t=t+1;
    Convergence_curve(t)=Leader_score;
    %
    [t Leader_score];
end



