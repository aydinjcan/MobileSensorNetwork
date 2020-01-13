
	figure
	u_2d = [];
	x = 1/M:1/M:(1-1/M);
	y =	 1/N:1/N:(1-1/N);
	[X,Y] = meshgrid(x,y);
	length_t = length(t);
	for k = 1:PLOTSTEP:length_t,
		subplot(1,2,1)
		u_2d = reshape(u(k,:),M-1,N-1)';
		surf(X, Y, u_2d);
		xlabel('x')
		ylabel('y')
		zlabel('u')
		caxis([-0.3, 0.8])
		axis([0, 1, 0, 1, -0.1, 1.1])
		colorbar
		if k < 10,
			fname = strcat('000', num2str(k),'.jpg');
		elseif  k >= 10 && k < 100,
			fname = strcat('00', num2str(k),'.jpg');
		elseif k >= 100 && k < 1000,
			fname = strcat('0', num2str(k),'.jpg');
		else
			fname = strcat(num2str(k), '.jpg');
        end
		subplot(1,2,2)
		for i = 1:NS,
            if (u(k,NS+1-i) > 0.01)
                plot(smove(k,i), smove(k,i+NS),'gx');
            elseif (u(k,NS+1-i) < -0.01)
                plot(smove(k,i), smove(k,i+NS),'yx');
            else
                plot(smove(k,i), smove(k,i+NS),'bx');
            end
			hold on
        end
        xlabel(num2str(t(k)))
		axis([0,1,0,1]);
		axis square;

		for i = 1:NA,
			plot(amove(k,i), amove(k,i+NA),'o');
			hold on
            % added 2006/09/02 to display desired positions of actuators
            plot(ActuatorDes(k,i), ActuatorDes(k,i+NA),'ro');
			hold on
        end
        
     	for i = 1:ND,
			plot(dinfo(k,i), dinfo(k,i+ND),'r*');
			hold on
		end
		hold off

		print('-djpeg', '-r72', fname);
		saveas(gcf, strcat(fname,'.fig'), 'fig')
		%mv(k) = getframe(gcf);
	end


