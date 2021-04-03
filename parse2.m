function obj=parse2(obj,FLDS)
%

    %FLDS={...
    %    'nMapBuffer',                   30,'bVetSigCtr'...
    %    ;'nMap',                        1,'bVetSigCtr'...

    %    ;'ctrORedgeORnon',              'non','bVetEdge'...
    %    ;'ctredgFORorEITHERorAGAINST',  'FOR','bVetEdge'...

    %    ;'zoneBufferRC',                -1,'bVetWidth'...
    %    ;'minMaxPixMap',                [18, inf],'bVetWidth'...
    %    ;'PszXY',                       [130 50],'bVetWidth'...
    %    ;'bTwoWay',                     0,'bVetWidth',...

    %    ;'zoneMinDensity',              0,'bVetDensity'...
    %    ;'bVetBranch',                  0,'bVetBranch'...
    %    ;'bVetSigCtr',                  0,'bVetSigCtr'...
    %    ;'bVetAgainst',                 0,'bVetAgainst'...
    %    ;'bVetFor',                     0,'bVetFor'...
    %    ;'bVetEither',                  0,'bVetEither'...
    %     };

    %obj=struct;
    %for i = 1:N
    %    fld=FLDS{i};
    %    obj.(fld)=[];
    %end
    %obj.nMapBuffer=[nan 30];
    %obj.ctrORedgeORnon='non';
    %obj.bVetEither=[0 1];
   
    ESIZES=cellfun(@numfun,FLDS(:,2));
    bCHAR=cellfun(@(x) all(ischar(x)),FLDS(:,2));
    EFSIZES=2*ESIZES;

    N=size(FLDS,1);
    [~,~,IND]=unique(FLDS(:,3));

    OVALS=cell(length(FLDS),1);
    OSIZES=zeros(length(FLDS),1);
    ORSIZES=zeros(length(FLDS),1);
    OCSIZES=zeros(length(FLDS),1);
    bFIRSTNAN=zeros(length(FLDS),1);
    bSECNDNAN=zeros(length(FLDS),1);
    ObCHAR=zeros(length(FLDS),1);
    for i = 1:N
        fld=FLDS{i};
        OVALS{i}=obj.(fld);
        if ischar(OVALS{i})
            ObCHAR(i)=1;
            obj.(fld)={obj.(fld)};
            OVALS{i}=obj.(fld);
        end

        if isempty(OVALS{i})
            continue
        end
        OSIZES(i)=numel(obj.(fld));
        ORSIZES(i)=size(obj.(fld),1);
        OCSIZES(i)=size(obj.(fld),2);
        if iscell(OVALS{i})
            if isempty(OVALS{i})
                continue
            elseif all(isempty(OVALS{i}{1})) || (~ischar(OVALS{i}{1} & all(isnan(OVALS{i}{1}))))
                bFIRSTNAN(i)=1;
            end
            if OSIZES(i) == 2 && (isempty(OVALS{i}{2}) || (~ischar(OVALS{i}{2} && all(isnan(OVALS{i}{2})))))
                bSECNDNAN(i)=1;
            end
            continue
        end
        if startsWith(fld,'b')
            zer=all(OVALS{i}(1:ESIZES(i)) == 0 );
        else
            zer=0;
        end
        bFIRSTNAN(i)=all(isnan(OVALS{i}(1:ESIZES(i)))) | zer;
        if OSIZES(i)==EFSIZES(i) || OSIZES(i)==EFSIZES(i)*2
            bSECNDNAN(i)=all(isnan(OVALS{i}(ESIZES(i)+1:end)));
        end
    end

    bEMPTY=OSIZES==0;
    bSINGLE=OSIZES==ESIZES;
    bDOUBLE=OSIZES==EFSIZES;
    bQUAD=ORSIZES==2;
    unq=transpose(unique(IND));
    for I = unq
        ind=IND==unq(I);
        i=find(ind,1,'first');
        bFld=[FLDS{i,3}];

        if all(bEMPTY(ind))
            obj.(bFld)=[0 0];
        elseif any(bQUAD(ind))
            ;
        elseif ~any(bDOUBLE(ind)) ~all(bFIRSTNAN(ind));
            obj.(bFld)=[1 0];
        elseif  ~any(bDOUBLE(ind)) && all(bFIRSTNAN(ind))
            obj.(bFld)=[0 0];
        elseif any(bDOUBLE(ind)) && ~all(bFIRSTNAN(ind)) && ~all(bSECNDNAN(ind))
            obj.(bFld)=[1 1];
        elseif any(bDOUBLE(ind)) && all(bFIRSTNAN(ind)) && ~all(bSECNDNAN(ind))
            obj.(bFld)=[0 1];
        elseif any(bDOUBLE(ind)) && ~all(bFIRSTNAN(ind)) && all(bSECNDNAN(ind))
            obj.(bFld)=[1 0];
        elseif any(bDOUBLE(ind)) && all(bFIRSTNAN(ind)) && all(bSECNDNAN(ind))
            obj.(bFld)=[0 0];
        end
    end

    for i = 1:N
        fld=FLDS{i,1};
        bFld=FLDS{i,3};
        if strcmp(fld,bFld) || isempty(obj.(bFld))
            continue
        end
        osize=OSIZES(i);
        def=FLDS{i,2};
        for j=1:2
            ind=(1:ESIZES(i))+(1-j).*ESIZES(i);
            %if bCHAR(i)
                %continue
            %end
            %[ORSIZES(i) OCSIZES(i) ESIZES2(i)]
            %if startsWith(fld,'b')
            %    %fld
            %    %ORSIZES(i)
            %   ;

            if ~obj.(bFld)(j) && ESIZES(i)==1
                if bCHAR(i)
                    obj.(fld){j}=nan(1);
                else
                    obj.(fld)(j)=nan(1);
                end
            elseif ~obj.(bFld)(j) && ESIZES(i)
                obj.(fld)(j,:)=nan(1,ESIZES(i));
            elseif obj.(bFld)(j) && ( OSIZES(i) < j || isempty(OVALS{i}) ||  (~iscell(OVALS{i}) && isnan(OVALS{i}(j)) || (iscell(OVALS{i}) && (all(isnan(OVALS{i}{j})) || isempty(OVALS{i}{j})  ))))
                if bCHAR(i)
                    obj.(fld){j}=def;
                else
                    obj.(fld)(j)=def;
                end
            end
        end

    end

end

function out=numfun(x)
    if ischar(x)
        out=1;
    else
        out=numel(x);
    end
end
