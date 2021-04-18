function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 21-Dec-2020 02:14:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @untitled_OpeningFcn, ...
    'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global flag2;
flag2=1;
set(handles.solution, 'Data', []);
set(handles.table,'data',cell(2,3));
set(handles.ltable, 'visible', 'off');
set(handles.utable, 'visible', 'off');
set(handles.ltxt, 'visible', 'off');
set(handles.utxt, 'visible', 'off');

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function size_Callback(hObject, eventdata, handles)
% hObject    handle to size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of size as text
%        str2double(get(hObject,'String')) returns contents of size as a double

size = str2double(get(handles.size, 'String'));

if isnan(size)
    f = msgbox('wrong format of n','Warning');
else
set(handles.table,'data',cell(size,size+1))
set(handles.table,'ColumnEditable',true)
end


% --- Executes during object creation, after setting all properties.
function size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in solve.
function solve_Callback(hObject, eventdata, handles)
% hObject    handle to solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ltable, 'visible', 'off');
set(handles.utable, 'visible', 'off');
set(handles.ltxt, 'visible', 'off');
set(handles.utxt, 'visible', 'off');
% get table data and b
table = get(handles.table,'Data');
n = str2double(get(handles.size,'String'));
A = str2double(table(:,1:n));
b = str2double(table(:,n+1));
global flag2;
if flag2==2
    A = table(:,1:n);
    b = table(:,n+1);
end
id= get(handles.selectMethod,'Value');
perc =str2double(get(handles.percision,'String'));
if isnan(perc) || perc < 2
    perc=4;
end
if sum(isnan(A(:)))
    A=zeros(n,n);
    id=8;
    f = msgbox('wrong format of A','Warning');  
end
if sum(isnan(b(:)))
    b=zeros(n,1);
     f = msgbox('wrong format of b','Warning');  
end

%call the selected method
switch id
    case 2  %gauss elimination
        tic
        [res,out]=Gauss_Elimination(A,b,perc);
        time=toc
        size_of_matrix=size(A,1)
        
        
    case 3  %gauss with pivoting
        tic
        [res,out]=pivoting(A,b,perc);
        time=toc
        size_of_matrix=size(A,1)
        
    case 4   % gauss jordan
        tic
        [res,out]=GJ(A,b,perc);
        time=toc
        size_of_matrix=size(A,1)
        
        
    case 5   % LU
        answer = questdlg('Choose Format of L U Decomposition', ...
            'Menu', ...
            'Downlittle','Crout','Chelosky','Chelosky');
        % Handle response
        switch answer
            case 'Downlittle'
                tic
                [l,u,res,out]=Downlittle(A,b,perc);
                time=toc
                size_of_matrix=size(A,1)
            case 'Crout'
                tic
                [l,u,res,out]=Crout(A,b,perc);
                time=toc
                size_of_matrix=size(A,1)
                
            case 'Chelosky'
                tic
                [l,u,res,out]=solveChelosky(A,b,perc);
                time=toc
                size_of_matrix=size(A,1)
            otherwise
                res=[];
                out='';
                l=[];
                u=[];
        end
        set(handles.ltable, 'visible', 'on');
        set(handles.ltable, 'Data', l);
        set(handles.utable, 'visible', 'on');
        set(handles.utable, 'Data', u);
        set(handles.ltxt, 'visible', 'on');
        set(handles.utxt, 'visible', 'on');
        
        
        
    case 6 %gauss siedil
        prompt={'Enter the initial guess for X:(enter values of x seperated by space)','Number of iterations','Absolute Relative error'};
        name='Input for Peaks function';
        numlines=2;
        defaultanswer={'','1','0.5'};
        options.Resize='on';
        answer=inputdlg(prompt,name,numlines,defaultanswer,options);
        initial= strsplit(answer{1});
        initial=str2double(initial);
        iter=str2double(answer{2});
        error=str2double(answer{3});
        
        tic
        [res,out]=Guass_seidel(A, b, initial', iter, error,perc);
        time=toc
        size_of_matrix=size(A,1)
        
    case 7 % jacobi
        prompt={'Enter the initial guess for X:(enter values of x seperated by space)','Number of iterations','Absolute Relative error'};
        name='Input for Peaks function';
        numlines=2;
        defaultanswer={'','1','0.5'};
        options.Resize='on';
        answer=inputdlg(prompt,name,numlines,defaultanswer,options);
        initial= strsplit(answer{1});
        initial=str2double(initial);
        iter=str2double(answer{2});
        error=str2double(answer{3});
        
        tic
        [res,out]=Jacobi(A, b, initial', iter, error,perc);
        time=toc
        size_of_matrix=size(A,1)
    otherwise
        res=[];
        out='';
end
set(handles.solution, 'Data', res);
set(handles.steps, 'String', out);




% --- Executes on button press in chooseFile.
function chooseFile_Callback(hObject, eventdata, handles)
% hObject    handle to chooseFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reading data from text file
[filename, path] = uigetfile('*.txt');
fullpath = strcat(path,filename);
fileID = fopen(fullpath,'rt');
data = fscanf(fileID,'%f,');
fclose(fileID);

% storing data & displaying it on the window
n = str2double(get(handles.size, 'String'));
tabledata = zeros(n,n+1);
k = 1;
global flag2;
flag2=2;
for i=1:n
    for j=1:n+1
        tabledata(i,j) = data(k);
        k = k + 1;
    end
end
set(handles.table,'Data',tabledata);

% --- Executes on selection change in selectMethod.
function selectMethod_Callback(hObject, eventdata, handles)
% hObject    handle to selectMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectMethod


% --- Executes during object creation, after setting all properties.
function selectMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applySize.
function applySize_Callback(hObject, eventdata, handles)
% hObject    handle to applySize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function steps_Callback(hObject, eventdata, handles)
% hObject    handle to steps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of steps as text
%        str2double(get(hObject,'String')) returns contents of steps as a double


% --- Executes during object creation, after setting all properties.
function steps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to steps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function percision_Callback(hObject, eventdata, handles)
% hObject    handle to percision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of percision as text
%        str2double(get(hObject,'String')) returns contents of percision as a double


% --- Executes during object creation, after setting all properties.
function percision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function steps_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to steps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
