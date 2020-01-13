
%plot with and without control
size_u=size(u);
with1=class'; %f17 stands for \beta=1.7
with2=without';
xpollution_i=zeros(size_u(1),1);
xpollution_un=zeros(size_u(1),1);
for i=1:size_u(1)
    for j=1:size_u(2)
        xpollution_i(i)=xpollution_i(i)+with1(i,j+1);
        xpollution_un(i)=xpollution_un(i)+with2(i,j+1);
    end
end
plot(t,xpollution_i,'b');
hold on
plot(t,xpollution_un,'r--');
xlabel('t');
ylabel('Total pollution');
legend('with control','without control');
axis([0 4 0 20]);


