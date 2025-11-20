%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course Number: ENGR 13300
% Semester: Spring 2025
%
% Description:
%     This program will calculate repayment values for a loan.
%
% Assignment Information:
%     Assignment:     15.3.2 MA2 Ind 2
%     Team ID:        LC0 - 00
%     Author:         Name, login@purdue.edu
%     Date:           03/24/2025
%
% Contributor:
%     Name, login@purdue [repeat for each]
%
%     My contributor(s) helped me:
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%     Note that if you helped somebody else with their code, you
%     have to list that person as a contributor here as well.
%
% Academic Integrity Statement:
%     I have not used source code obtained from any unauthorized
%     source, either modified or unmodified; nor have I provided
%     another student access to my code.  The project I am
%     submitting is my own original work.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION

% define the loan parameters
P = 500000;     % principle (USD)
r_year = 0.07;  % interest rate (annual percent)
n_year = input("Input the number of years for repayment. ");    % years to repay
%n_year = 30; % years to repay

%% ____________________
%% CALCULATIONS

% convert to monthly payments
r = r_year/12;      % monthly interest rate
n = n_year*12;      % number of monthly payments
pays = 1:n;         % vector of payment month numbers

% fixed monthly payment, A (USD)
A = (P*(r*(1+r)^n))/((1+r)^n-1);

% initialize the values for the loop
k = 1;
portion = ((1+r).^-(n-k+1));
portion2 = ((1+r)^-(n-k+1));
summed_terms = ((1+r).^-(n-k+1));
total_pay = A * k;
for k = 2:n
    portion(k) = ((1+r)^-(n-k+1));
    summed_terms(k) = summed_terms(k-1) + ((1+r)^-(n-k+1));
    total_pay(k) = A * k;
end

% % alternative loop solution
% totalPay = A*pays;
% terms_in_sum = ((1+r).^-(n-pays+1));
% summed_terms = terms_in_sum(1);
% S = A*summed_terms;
% for index = 2:n
%     summed_terms(index) = summed_terms(index-1) + terms_in_sum(index);
%     S(index) = A*summed_terms(index);
% end


% find the number of months it takes for the principal
% payment to exceed the interest payment

for k=1:n
    exceed_time = k;
    if portion(k) >=0.5
        break
    end
end


% calculate the cumulative principle paid, S (USD)
S = A*summed_terms;
total_repaid = total_pay(end);
interest = total_repaid - P;

%% ____________________
%% OUTPUTS

fprintf('The principal amount is $%.0f.\n', P)
fprintf('The annual interest rate is %.2f%%.\n', r_year*100)
fprintf('The repayment period is %.0f years.\n', n_year)
fprintf('The total amount repaid is $%0.2f.\n', total_repaid)
fprintf('The total amount of interest paid is $%0.2f.\n', interest)
fprintf(['The payments on the principal exceed the payments on the interest ' ...
         'after %.0f months.\n'], exceed_time)
