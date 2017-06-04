load('V:\Academic\8th Sem\BTP\EmotionAnalysis\src\deapdata\s01.mat')
x=data(1,1,:);
for i = 1:8064
    y = x(1,1,i);
    z(i)=y;
end
plot(z);