function varargout = FilterTest(varargin)
% FILTERTEST M-file for FilterTest.fig
%      FILTERTEST, by itself, creates a new FILTERTEST or raises the existing
%      singleton*.
%
%      H = FILTERTEST returns the handle to a new FILTERTEST or the handle to
%      the existing singleton*.
%
%      FILTERTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERTEST.M with the given input arguments.
%
%      FILTERTEST('Property','Value',...) creates a new FILTERTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FilterTest_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FilterTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help FilterTest

% Last Modified by GUIDE v2.5 27-Sep-2004 09:10:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FilterTest_OpeningFcn, ...
                   'gui_OutputFcn',  @FilterTest_OutputFcn, ...
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


% --- Executes just before FilterTest is made visible.
function FilterTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FilterTest (see VARARGIN)

% Choose default command line output for FilterTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FilterTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);

handles.picData = 0;


% --- Outputs from this function are returned to the command line.
function varargout = FilterTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txt_size_Callback(hObject, eventdata, handles)
% hObject    handle to txt_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_size as text
%        str2double(get(hObject,'String')) returns contents of txt_size as a double


% --- Executes during object creation, after setting all properties.
function txt_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txt_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to txt_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_sigma as text
%        str2double(get(hObject,'String')) returns contents of txt_sigma as a double


% --- Executes during object creation, after setting all properties.
function txt_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in btn_openFile.
function btn_openFile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[fileName, pathName] = uigetfile('*.bmp', 'Select an image');
if isequal(fileName,0) | isequal(pathName,0)
    disp('User selected Cancel');
else
    fullPath = [pathName fileName];
    AxisHandle = findobj('Tag', 'axes_picor');
    axes(handles.axes_picor);
    ImData = imread(fullPath);
    ImH = ImData(1:2:end,:);
    handles.picData = ImH;%str2double(str{val});
    guidata(hObject,handles);

    axis(AxisHandle);

    ImHandle = imagesc(ImH);
    set(AxisHandle, ...
        'Tag', 'axes_picor', ...
        'UserData', ImData);
    colormap gray;
    % Show the title:
    TitleHandle = findobj('Tag', 'txt_title');
    [pathstr, FileName, FileExt] = fileparts(fullPath);
    set(TitleHandle, 'String', FileName);


end



% --- Executes on button press in btn_filter.
function btn_filter_Callback(hObject, eventdata, handles)
% hObject    handle to btn_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
size = str2num(get(handles.txt_size,'String'));
sigma = str2num(get(handles.txt_sigma,'String'));

picFilter = fspecial('log',size,sigma)*-1; %size 30 sigma 5

AxisHandle = findobj('Tag', 'axes_filter');
axes(handles.axes_filter);
mesh(picFilter);
colormap(hsv(128));

pictureData = handles.picData;
pictureFiltered = filter2(picFilter,pictureData);

ind = find(pictureFiltered <= (max(pictureFiltered(:))-mean(pictureFiltered(:)))/2);
pictureFiltered(ind) = 0;

AxisHandle = findobj('Tag', 'axes_picfi');
axes(handles.axes_picfi);

imagesc(pictureFiltered); 
colormap gray;


