%*****建立速度模型********
%x为横坐标,为向量
%z为纵坐标，为向量，表示地下深度，假设速度越往下传播值越大
%k为断层的斜率
%h为断层的截距
function [Vp,Vs,Rho]=buildingModel(x,z,k,h)
xn=length(x);
zn=length(z);
Vp=zeros(zn,xn);%
Vs=zeros(zn,xn);
Rho=zeros(zn,xn);
%********************倾斜层状介质模型**********************
% for j=1:xn
%     for i=1:zn
%         if i<=50
%              Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000; 
%         elseif i<=150+round(1/12*j)
%              Vp(i,j)=2000;Vs(i,j)=0;Rho(i,j)=2000;
%         else
%              Vp(i,j)=2500;Vs(i,j)=0;Rho(i,j)=4000;
%         end
%     end
% end
 %********************含有断层、介质层倾斜的复杂层状介质模型**********************

 for j=1:xn
      for i=1:zn
        if i<=50&&i<=k*j-h
             Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000; 
        elseif i<=100+round(1/12*j)&&i<=k*j-h
             Vp(i,j)=1700;Vs(i,j)=0;Rho(i,j)=1100;
        elseif i<=150+round(-1/8*j)&&i<=k*j-h
             Vp(i,j)=2000;Vs(i,j)=0;Rho(i,j)=2500;
        elseif i<=20+round(-1/8*j)&&i>k*j-h
             Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000;
        elseif i<=70+round(1/12*j)&&i>k*j-h
             Vp(i,j)=1700;Vs(i,j)=0;Rho(i,j)=1100; 
        elseif i<=120+round(-1/8*j)&&i>k*j-h
             Vp(i,j)=2000;Vs(i,j)=0;Rho(i,j)=2500;
         else
             Vp(i,j)=2500;Vs(i,j)=2500;Rho(i,j)=4000;
        end
      end
 end

 %%%***************展示断层的位置*************%%%%%%%%%%%%
 z=k.*x-h;
 figure(1);imagesc(Vp);
 figure(2);mesh(Vp);
 figure(3);
%  imagesc(Vp);
%  hold on 
 plot(x,z,'r+');
 
%          for i=1:zn
%         if i<=20
%              Vp(i,j)=1500;Vs(i,j)=1500;Rho(i,j)=1000; 
%         elseif i<=170+round(1/12*j)
%              Vp(i,j)=1700;Vs(i,j)=1700;Rho(i,j)=1100;
%         elseif i<=470+round(-1/8*j)
%              Vp(i,j)=2000;Vs(i,j)=2000;Rho(i,j)=2500;
%         else
%              Vp(i,j)=2500;Vs(i,j)=2500;Rho(i,j)=4000;
%         end
%          end
%     end
%  end
%********************小偏移距复杂层状介质模型**********************
%  for j=1:xn
%     for i=1:zn
%         if i<=50
%              Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000; 
%         elseif i<=200+round(1/12*j)
%              Vp(i,j)=1700;Vs(i,j)=0;Rho(i,j)=1100;
%         elseif i<=500+round(1/10*j)
%              Vp(i,j)=2000;Vs(i,j)=0;Rho(i,j)=2500;
%         else
%              Vp(i,j)=2500;Vs(i,j)=0;Rho(i,j)=4000;
%         end
%     end
%  end
% *****************不含反射层*****************************
% for j=1:xn
%     for i=1:zn
%         Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000;
%     end
% end
%********************3层状介质模型**********************
% for j=1:xn
%     for i=1:zn
%         if i<=50
%              Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000;
%         elseif i>50&&i<=70
%              Vp(i,j)=2000;Vs(i,j)=0;Rho(i,j)=1500;
%         elseif i>70&&i<=120
%              Vp(i,j)=2200;Vs(i,j)=0;Rho(i,j)=1700;
%         elseif i>120&&i<=140
%              Vp(i,j)=3000;Vs(i,j)=0;Rho(i,j)=2000;
%         elseif i>140&&i<=200
%              Vp(i,j)=4500;Vs(i,j)=0;Rho(i,j)=3000;
%         elseif i>200&&i<=250
%             Vp(i,j)=2800;Vs(i,j)=0;Rho(i,j)=2100;
%         else 
%             Vp(i,j)=4000;Vs(i,j)=0;Rho(i,j)=2800;
%         end
%     end
% end
%********************1层状介质模型**********************
% for j=1:xn
%     for i=1:zn
%         if i<=50
%              Vp(i,j)=1900;Vs(i,j)=0;Rho(i,j)=1000;
%         else
%              Vp(i,j)=2000;Vs(i,j)=0;Rho(i,j)=2500;
%         end
%     end
% end
%********************水平层状介质模型**********************
% for j=1:xn
%     for i=1:zn
%         if i<=50
%              Vp(i,j)=1900;Vs(i,j)=0;Rho(i,j)=1000; 
%         elseif i<=150
%              Vp(i,j)=2000;Vs(i,j)=0;Rho(i,j)=2500;  
%         else
%              Vp(i,j)=2200;Vs(i,j)=0;Rho(i,j)=4000;
%         end
%     end
% end
% ********************5层状介质模型**********************
% for j=1:xn
%     for i=1:zn
%         if i<=50
%              Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000;
%         elseif i>50&&i<=100
%              Vp(i,j)=2500;Vs(i,j)=0;Rho(i,j)=2300;
%         elseif i>100&&i<=180
%              Vp(i,j)=3000;Vs(i,j)=0;Rho(i,j)=4000;
%         else
%              Vp(i,j)=2000;Vs(i,j)=0;Rho(i,j)=2500;
%         
%         end
%     end
% end
% ********************5层中的1层状介质模型*****************
% for j=1:xn
%     for i=1:zn
%         if i<=50
%              Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000;
%         else
%              Vp(i,j)=2500;Vs(i,j)=0;Rho(i,j)=2300;
%         
%         end
%     end



% end
% ********************5层中的1,2层状介质模型*****************
% for j=1:xn
%     for i=1:zn
%         if i<=50
%              Vp(i,j)=1500;Vs(i,j)=0;Rho(i,j)=1000;
%         elseif i>50&&i<=100
%              Vp(i,j)=2500;Vs(i,j)=0;Rho(i,j)=2300;
%         else 
%              Vp(i,j)=3000;Vs(i,j)=0;Rho(i,j)=4000;  
%         end
%     end
% end