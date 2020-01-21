function varargout = inicializace_a_deleni(varargin)
% INICIALIZACE_A_DELENI MATLAB code for inicializace_a_deleni.fig
%      INICIALIZACE_A_DELENI, by itself, creates a new INICIALIZACE_A_DELENI or raises the existing
%      singleton*.
%
%      H = INICIALIZACE_A_DELENI returns the handle to a new INICIALIZACE_A_DELENI or the handle to
%      the existing singleton*.
%
%      INICIALIZACE_A_DELENI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INICIALIZACE_A_DELENI.M with the given input arguments.
%
%      INICIALIZACE_A_DELENI('Property','Value',...) creates a new INICIALIZACE_A_DELENI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before inicializace_a_deleni_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to inicializace_a_deleni_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help inicializace_a_deleni

% Last Modified by GUIDE v2.5 01-Mar-2018 18:02:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @inicializace_a_deleni_OpeningFcn, ...
    'gui_OutputFcn',  @inicializace_a_deleni_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before inicializace_a_deleni is made visible.
function inicializace_a_deleni_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to inicializace_a_deleni (see VARARGIN)
set(handles.figure1,'units','norm','outerposition',[0 0 1 1]);

handles.data=varargin{1};

global vysledky h vysledky_1 snimek_num

snimek_num=1;

vysledky=repmat({[]},[1 size(handles.data,3)]);

vysledky_1=varargin{2};


imshow(squeeze(handles.data(:,:,snimek_num,:)))
hold on
h=plot([],[],'*r');

handles=prepis(handles);


set(handles.figure1,'WindowButtonDownFcn',@MousePress);
set(handles.figure1, 'WindowKeyPressFcn', @KeyPress);

% Choose default command line output for inicializace_a_deleni
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes inicializace_a_deleni wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = inicializace_a_deleni_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global vysledky_1
varargout{1} = vysledky_1;




function MousePress(src,eventdata)
handles = guidata(gcbo);


cursor = get(gca,'CurrentPoint');
cursor = round(cursor(1,[1,2]));
tlacitko=get(gcf,'SelectionType');

global vysledky_1 snimek_num

if cursor>0
    
    if snimek_num==1
        
        if strcmp(tlacitko,'normal')
            
            vysledky_1=[vysledky_1;cursor(1) cursor(2)];
            handles=prepis(handles);
        end
        
        if strcmp(tlacitko,'alt')
            tecky=vysledky_1;
            if ~isempty(tecky)
                
           
            [nanic,nejmin]=min((tecky(:,1)-cursor(1)).^2+(tecky(:,2)-cursor(2)).^2);
            
            if nanic <200
            tecky(nejmin,:)=[];
            
            vysledky_1=tecky;
            handles=prepis(handles);
            
            end
            
            end
        end
        
        
    else
        
        if strcmp(tlacitko,'normal')
            
            handles=prepis(handles);
        end
        
        if strcmp(tlacitko,'alt')
            
            handles=prepis(handles);
        end
        
        
        
        
        
        
    end
    
    
end
% guidata(hObject, handles);
guidata(gcbo,handles) 

function KeyPress(Source, eventdata)
handles = guidata(gcbo);

global snimek_num

if strcmp('rightarrow',eventdata.Key)
    snimek_num=snimek_num+1;
    
    if snimek_num>size(handles.data,3)
        snimek_num=size(handles.data,3);
    end
    hold off
    imshow(squeeze(handles.data(:,:,snimek_num,:)))
    hold on
    handles=prepis(handles);
end


if strcmp('leftarrow',eventdata.Key)
    snimek_num=snimek_num-1;
    if snimek_num<1
        snimek_num=1;
    end
    hold off
    imshow(squeeze(handles.data(:,:,snimek_num,:)))
    hold on
    
    handles=prepis(handles);
    
end
% guidata(hObject, handles);
guidata(gcbo,handles) 



function handles=prepis(handles)

global vysledky h vysledky_1 citac snimek_num
% h=handles.plotik;
delete(h)


    if snimek_num==1
    
        vys=vysledky_1;
        if ~isempty(vys)
            h=plot([vys(:,1)],[vys(:,2)],'*r');
        end
    else
       
        if mod(citac,2)==1
        end
        
    
   end
% guidata(hObject, handles);



