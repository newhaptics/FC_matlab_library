close all
clear all
figure(1);
hold on;
toggle=0;
turnaround = zeros(5,1);
cc=hsv(6);
for i=2:6
    toggle=0;
    M = dlmread(['disp' num2str(i) 'disp1_p15_t150_d1.8_r2_c3_m1_vE'],'\t',1,1);
    for j=2:length(M)
        if (M(j,2) < M(j-1,2) && toggle == 0 )
            turnaround(i)=j-1;
            toggle=1;
        end
    end
    uprange=1:turnaround(i);
    downrange=turnaround(i):length(M);
    plot(M(uprange,1),M(uprange,2),'-','color',cc(i,:));
    plot(M(downrange,1),M(downrange,2),'--','color',cc(i,:));
    legend;
    clear M
    
end