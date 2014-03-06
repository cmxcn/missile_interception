





clear all;
clc;
tspan = 50;
downPoint = 20000;
tStart = 0;

I = 0;
D = 0;
P = 4;
t = 0;%sync timer
%initial missile info
XMnow = 0;
YMnow = 0;
VMnow = 1200;
VMtheta = 20*pi/180;
DVMtheta = 0;
%initial target info
XTnow = 42220+downPoint;
YTnow = 15000;
VTxnow = -900;
VTynow = 0;
VTnow = 900;
VT0 = 900;
VTtheta = 0;
nmax = 600; %10g acce
XM = [XMnow];
YM = [YMnow];
XT = [XTnow];
YT = [YTnow];
Rnow = sqrt((XTnow - XMnow)^2 + (YTnow - YMnow)^2);
NM = [0];
stepLen = 0.1;%one step for 100ms
missDistance = 5;
TimeLine = [t];
changeFlag = 0;
figure(1);
plot(XTnow,YTnow,'g',XMnow,YMnow,'r');
q0 = atan2(YTnow-YMnow, XTnow-XMnow);
hold on;
while t < tspan && Rnow > missDistance 
    t = t+stepLen;% one step for 1ms
    TimeLine = [TimeLine t];

    NM = [NM DVMtheta*VMnow/stepLen];
    VMtheta = VMtheta + DVMtheta;
    VMxnow = VMnow*cos(VMtheta);
    VMynow = VMnow*sin(VMtheta);
    XMnow = XMnow + VMxnow*stepLen;
    YMnow = YMnow + VMynow*stepLen;

    XM = [XM XMnow];
    YM = [YM YMnow];
    
    VTxnow = -VTnow*cos(VTtheta);
    VTynow = -VTnow*sin(VTtheta);
    XTnow = XTnow + VTxnow*stepLen;
    YTnow = YTnow + VTynow*stepLen;
    jiaodu = acos((VMxnow*(-VTxnow)+VMynow*(-VTynow))/sqrt(VMxnow^2+VMynow^2)/sqrt(VTxnow^2+VTynow^2));
    XT  = [XT XTnow];
    YT = [YT YTnow];
    q1 = atan2(YTnow-YMnow, XTnow-XMnow);
    Dq = q1-q0;
    q0 = q1;
    
    Rnow = sqrt((XTnow - XMnow)^2+(YTnow - YMnow)^2);
    if Rnow <= missDistance
        break;
    end
    if t >= tStart  % missile begins to move
        
        VMnow = 1000;
        changeFlag = 0;
        if Rnow <= 10000 %change the guidance law
            if changeFlag == 0 
              changeFlag = 1;
              plot(XMnow, YMnow,'o',XTnow,YTnow,'o');
              
              stepLen = 0.001;
            end
        end
        
        if changeFlag == 0 %haven't changed to auto guide
            VMtheta = 20*pi/180;
            DVMtheta = 0;
        else
            
          %  DVMtheta = PIDCalc(P,I,D,Dq);
            DVMtheta = 4*Dq;
            NMnow = DVMtheta*VMnow/stepLen;
            if NMnow > nmax
                DVMtheta = nmax/VMnow*stepLen;
            else if NMnow < -nmax
                    DVMtheta = -nmax/VMnow*stepLen;
                end
            end

        end
    else 
        VMnow = 0;
        DVMtheta = 0;
    end

    
    if( t >= 0 ) % target angle begins to change
        VTtheta = (0.25*(t)+0.00035*(t)^3)*pi/180;
        if VTtheta > 70*pi/180
            VTtheta = 70*pi/180;
        end
    else   VTtheta = 0;
    end
    if( t >= 30 ) % target velocity begins to change
        VTnow = VTnow - 9*(VT0/1220)^2*stepLen;
    else VTnow = VTnow;
    end

end

plot(XT,YT,'g',XM,YM,'r');
xlabel('水平距离：m');
ylabel('竖直距离：m');
legend('目标轨迹','导弹轨迹', 'Location','SouthEast');

figure(2);
plot(TimeLine, NM);
xlabel('时间：s');
ylabel('法向加速度：m/s^2');
jiaodu*180/pi
