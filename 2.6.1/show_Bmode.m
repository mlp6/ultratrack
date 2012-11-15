  
        figure(2);clf
        r = ((0:size(rf,1)-1)*(1/probe.field_sample_freq)+t0)*(probe.c/2);
        [th0 dth] = meshgrid(beamset.directionx,beamset.rx_offset(:,3));
        th = th0+dth;
        [Th R] = meshgrid(th(:),r);
        x0 = beamset.originx;
        [dTX dRX] = meshgrid(beamset.originx-0*beamset.apex*tan(beamset.directionx),beamset.rx_offset(:,1));
        
        dX =dTX(:)+dRX(:)-beamset.apex*tan(th(:));
        X = R.*sin(Th) + repmat(dX',size(Th,1),1);
        Z = R.*cos(Th);
        env = abs(hilbert(reshape(permute(rf,[1 4 2 3]),size(rf,1),[])));env = env*1e21;%/max(env(:));
        im = surf(1e3*X,1e3*Z,0*R,db(env));
        set(gca,'color',[0.1 0.1 0.1])
        axis ij
        axis image
        set(im,'EdgeColor','none')
        view([0 90]);
        caxis([-40 0])
        colormap gray
        hold on
        if isfield(phantom.PPARAMS,'pointscatterers');
                    [xpos ypos zpos] = ndgrid(phantom.PPARAMS.pointscatterers.x,phantom.PPARAMS.pointscatterers.y,phantom.PPARAMS.pointscatterers.z);
                     wire_positions = [xpos(:) ypos(:) zpos(:)]; %xyz Scatterer Locations [m]
                     wire_amplitudes = phantom.PPARAMS.pointscatterers.a*ones(size(wire_positions,1),1);
                        plot(1e3*wire_positions(:,1),1e3*wire_positions(:,3),'y+')
        end
        p = patch(10*[phantom.PPARAMS.ymin phantom.PPARAMS.ymax phantom.PPARAMS.ymax phantom.PPARAMS.ymin],...
            -10*[phantom.PPARAMS.zmax phantom.PPARAMS.zmax phantom.PPARAMS.zmin phantom.PPARAMS.zmin],'y');
        
        p1 = patch(1e3*[-0.5 0.5 0.5 -0.5]*(probe.width_x+probe.kerf_x)*probe.no_elements_x,[0 0 -1 -1],'m');
        plot(0,1e3*beamset.apex,'m*')
        set(p,'FaceColor','None','EdgeColor','c')
        axis tight
        xl = get(gca,'xlim');set(gca,'xlim',[xl(1) - 0.1*diff(xl) xl(2)+0.1*diff(xl)]);
        yl = get(gca,'ylim');set(gca,'ylim',[yl(1) - 0.1*diff(yl) yl(2)+0.1*diff(yl)]);
        zoom reset
        keyboard