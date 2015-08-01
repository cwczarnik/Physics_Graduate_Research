clc
disp('load Data file first in to your working directory');
runtype = input('What kind of structure are you plotting?','s');
xlength = input('length of sample in x (cm)');
ylength = input('length of sample in y(cm)');
RealEfield = real(Data{2});%selecting real values of the field
freq_list_inGhz = Data{1}/(10^9);% frequency list in Ghz
%pick the frequency data point you want to plot. this will depend on how
%many points VNA was set to take.
%%
Want=false;
while ~Want
    Q = input('make a movie (1) of a range of freq or just a single(anything else)? ','s');
    if Q =='1';
        Want = false;
        ghz_start = input('start freq: ');
        ghz_end = input('end freq: ');
        ghz_range = ghz_start:0.05:ghz_end;
        N = length(ghz_range); % or use input('number of iterations at 0.05 GHz increments: ');
        M(1,1:N) = struct('cdata', [],...
                        'colormap', []);
        for i = 1:N
            Ghz = ghz_start+i*0.05;
            format long;
            Find_closest=abs(freq_list_inGhz-Ghz);
            [Diff_in_Ghz point_of_interest] = min(Find_closest);% calculates the closest
            %frequency to the desired 

            Desired_Freq_E = RealEfield(point_of_interest,:,:);%select the wanted frequency data
            [notcare xdim ydim] = size(Desired_Freq_E);

            fig1 = figure(1);
            winsize = get(fig1,'Position');
            numframes = N;
            
            set(gcf, 'nextplot','replacechildren');
    
            x = linspace(0,xlength,xdim);
            y = linspace(0,ylength,ydim);
            imagesc(x,y,reshape(Desired_Freq_E,[xdim,ydim]))
            shading flat;
            axis equal;
            xlim([0,xlength])
            ylim([0,ylength])
            colorbar;
            %%
            caxis([-0.005,0.005]);
            xlabel('Distance (cm)','fontsize',14);
            ylabel('Distance (cm) ','fontsize',14);
            str=sprintf('%s for %d cm %d  cm : E-field for Frequency = %dGhz',runtype,xlength,ylength,Ghz);
            title(str)
            
           M(1,i) = getframe(gcf);
            pause(.001);
           
           

        end
    filename = sprintf('%s%d .avi',runtype);
    movie2avi(M,filename,'FPS',4,'compression', 'None');
    disp('just ctrl+c to escape here!')
    else
        %%copy of previous code not using a for loop to plot and view data
        disp('plot an individual frequency')
        Ghz = input('which frequency to plot? Enter in Ghz: ');
        format long;
        Find_closest = abs(freq_list_inGhz-Ghz);
        [Diff_in_Ghz point_of_interest] = min(Find_closest);% calculates the closest
        %frequency to the desired 

        Desired_Freq_E=RealEfield(point_of_interest,:,:);%select the wanted frequency data
        [notcare xdim ydim] = size(Desired_Freq_E);
        fig1 = figure(1);

        x = linspace(0,xlength,ydim);
        y = linspace(0,ylength,xdim);
        v = linspace(-0.1,0.1,400);
        imagesc(x,y,reshape(Desired_Freq_E,[xdim,ydim]))
        shading flat;
        axis equal;
        xlim([0,xlength])
        ylim([0,ylength])
        colorbar;
        caxis([-0.01,0.01]);
        
        xlabel('Distance (cm)','fontsize',14);
        ylabel('Distance (cm) ','fontsize',14);
            str=sprintf('%s for %d cm by %d cm : E-field for Frequency = %d Ghz',runtype,xlength,ylength,Ghz);
        title(str)
        filename = sprintf('%s.%dGhz.jpg',runtype,Ghz);
        saveas(fig1,filename)
        break

    end

end