% Random Run
%Set Maximum and minimum distances you want to run
maxd=12;    %max 10, min 4 gives mean 7.52
mind=8;
% Set Home coordinates   %1933 Monroe
homelat=43.063989;       %43.063989;
homelon=-89.418578;      %-89.418578;


k=kmz2struct('Run Nodes.kmz');  %Load intersection coordinates
for i=1:length(k)
    name=string(k(i).Name);
    lat(str2num(name))=k(i).Lat;
    lon(str2num(name))=k(i).Lon;
end

%Locate closest intersection to home, use for initial distance in mi
[d0,homenode]=min(distance(lat,lon,homelat,homelon,referenceEllipsoid('GRS80')));
d0=distdim(d0,'m','mi');

%Mark intersections and home on map
geoplot(lat,lon,'r.','MarkerSize',8.0)
hold on
geoplot(homelat,homelon,'rp','MarkerSize',10,'MarkerFaceColor','r')
hold on

%Load in excel with distances between intersections. 167x167 matrix
dis=xlsread('Random Run Distances.xlsx');
dis=dis(2:end,2:end);
dis(dis==0)=NaN;

% nodess=[]; %distances=[];     %For distributions
% for l=1:1000
% disp(num2str(l))

dfinal=0;
%Iterate until route is proper distance
while dfinal>maxd || dfinal<mind
    nodes=[homenode];
    numnodes=1;
    h=0;
    d=2*d0;
    routelatlon=[homelat,homelon; lat(homenode),lon(homenode)];
    
    while h~=1; %Not home
        nextnodes=[find(~isnan(dis(nodes(end),:))==1),...
            find(~isnan(dis(:,nodes(end)))==1)']; %Possible next intersects
        
        %Make it easier to close the loop. Avoid close misses
        if numnodes>2 & ismember(homenode,nextnodes)
            nodes(numnodes+1)=homenode;
            h=1;
        else
            %Avoid backtracking, double looping unless unavoidable ie picnic point
            if numnodes>1 & ~ismember([9, 124, 125],nodes(end))
                nn=setdiff(nextnodes,nodes); %Can't go back to previous intsersection
                if isempty(nn)
                    nextnodes(nextnodes==nodes(numnodes-1))=[]; % No backtracking
                else
                    nextnodes=nn;
                end
                %Choose next intersect with weighted random selection
                P2=[lon(nextnodes)', lat(nextnodes)'];
                P1=[lon(nodes(end)), lat(nodes(end))];
                P0=[lon(nodes(end-1)),lat(nodes(end-1))];
                n1 = (P2 - P0) / norm(P2 - P0);
                n2 = (P1 - P0) / norm(P1 - P0);
                cosangles=[];
                for j=1:length(nextnodes)
                    cosangles(j)=abs(dot(n1(j,:),n2)); %Weighting--avoid turns
                end
                %Weighted Random Selection
                nodes(numnodes+1)=nextnodes(randsample(length(nextnodes),1,true, cosangles));
                %angle3 = atan2(norm(cross(n1, n2)), dot(n1, n2));  % Stable
            else
                %When backtracking is unavoidable
                nodes(numnodes+1)=nextnodes(randi(length(nextnodes)));
            end
        end
        d=d+dis(min(nodes(end-1:end)),max(nodes(end-1:end)));
        routelatlon=[routelatlon; lat(nodes(end)), lon(nodes(end))];
        numnodes=numnodes+1;
    end
    dfinal=d;
end

%nodess=[nodess, nodes]; %distances(l)=dfinal;        % For Distribution
%end
% latss=lat(nodess);
% lonss=lon(nodess);
% [N,c]=(hist3([lonss',latss'], 'Nbins',[25, 25]));
% [x,y]=meshgrid(cell2mat(c(1)),cell2mat(c(2)));
% N=log(N);
% N(N<0)=0;
% geoplot(lat,lon,'r.','MarkerSize',8.0)
% hold on
% geoplot(homelat,homelon,'rp','MarkerSize',10,'MarkerFaceColor','r')
% hold on
% geopcolor(x,y,N)

% Colored route map with distance in title
c=hsv(numnodes+1);
routelatlon=[routelatlon ; homelat, homelon];
for i=1:length(routelatlon)-1
    geoplot(routelatlon(i:i+1,1),routelatlon(i:i+1,2),'Color',c(i,:),'LineWidth',2.0);
end
title(['A randomly generated ' num2str(round(d,2)) ' mile run'])
geobasemap('streets')



% Checking distance accuracy with previous runs I've done.
% Result: calculated distance is accurate to within 5%
% presetnodes1=[160, 84, 85, 87, 89, 91, 92, 113, 112, 111, 110, 106, 1, 160];
% presetnodes2=[160, 1, 106, 3, 4, 35, 6, 14, 15, 34, 33, 5, 103, 104, 101, 155,...
%     100, 81, 82, 127, 83, 160];
% presetnodes3=[160, 1, 81, 80, 72, 71, 68, 67, 100, 155, 101, 104, 2, 1, 160];
% presetnodes4=[160, 84, 85, 129, 131, 132, 130, 133, 129, 85, 84, 160];
% presetnodes5=[160, 84, 83, 127, 82, 81, 100, 155, 101, 147, 102, 103, 5, 3, 105, 2, 1, 160];
% 
% presetnodes=presetnodes5;
% d=2*d0;
% routelatlon=[homelat,homelon; lat(homenode),lon(homenode)];
% for k=1:length(presetnodes)-1
%     d=d+dis(min(presetnodes(k:k+1)),max(presetnodes(k:k+1)));
%     routelatlon=[routelatlon; lat(presetnodes(k)), lon(presetnodes(k))];
% end
% disp(d)
% routelatlon=[routelatlon ; lat(presetnodes(end)), lon(presetnodes(end)); ...
%     homelat, homelon];
% for i=1:length(routelatlon)-1
%     geoplot(routelatlon(i:i+1,1),routelatlon(i:i+1,2),'Color',c(i,:),'LineWidth',2.0);
%     hold on
% end



