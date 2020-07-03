function varargout = Simple_GUI(varargin)
% SIMPLE_GUI M-file for Simple_GUI.fig
%      SIMPLE_GUI, by itself, creates a new SIMPLE_GUI or raises the existing
%      singleton*.
%
%      H = SIMPLE_GUI returns the handle to a new SIMPLE_GUI or the handle to
%      the existing singleton*.
%
%      SIMPLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLE_GUI.M with the given input arguments.
%
%      SIMPLE_GUI('Property','Value',...) creates a new SIMPLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VL_test_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simple_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Simple_GUI

% Last Modified by GUIDE v2.5 18-May-2009 11:08:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simple_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Simple_GUI_OutputFcn, ...
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


% --- Executes just before Simple_GUI is made visible.
function Simple_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simple_GUI (see VARARGIN)

% Choose default command line output for Simple_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Simple_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Simple_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SineButton.
function SineButton_Callback(hObject, eventdata, handles)
% hObject    handle to SineButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x = 0:0.1:10;
y = sin(x);
myAxis = findobj('Tag', 'myAxis')
axes(myAxis);
plot(x,y);
set(myAxis, 'Tag', 'myAxis', ...
    'UserData', [x;y]);
shg

TagHandle = findobj('Tag', 'TitleText');
set(TagHandle, 'String', 'Now it it a Sine-wave.');



% --- Executes on button press in RandomButton.
function RandomButton_Callback(hObject, eventdata, handles)
% hObject    handle to RandomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x = 0:0.1:10;
y = rand(size(x));
myAxis = findobj('Tag', 'myAxis');
axes(myAxis);
plot(x,y);
% Comment: I found that in Matlab 7, the "plot" command removes the "axes"-Tag: I
% think that this is a bug!
set(myAxis, 'Tag', 'myAxis', ...
    'UserData', [x;y]);

TagHandle = findobj('Tag', 'TitleText')
set(TagHandle, 'String', 'Now it is random.');

% shgdata = get(myAxis, 'UserData');


% --- Executes on button press in IncButton.
function IncButton_Callback(hObject, eventdata, handles)
% hObject    handle to IncButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myAxis = findobj('Tag', 'myAxis');
data = get(myAxis, 'UserData');
x = data(1,:);
yOld = data(2,:);
yNew = yOld .* linspace(1, 2, length(yOld));
axes(myAxis);
plot(x, yNew);
set(myAxis, 'Tag', 'myAxis', ...
    'UserData', [x;yNew]);

% --- Executes on button press in DecButton.
function DecButton_Callback(hObject, eventdata, handles)
% hObject    handle to DecButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myAxis = findobj('Tag', 'myAxis');
data = get(myAxis, 'UserData');
x = data(1,:);
yOld = data(2,:);
yNew = yOld .* linspace(1, 0.5, length(yOld));
axes(myAxis);
plot(x, yNew);
set(myAxis, 'Tag', 'myAxis', ...
    'UserData', [x;yNew]);
