function proc_input(hObject,handles,lowlimit,highlimit)
a=str2double(get(hObject,'String'));
if isnan(a),
    set(hObject,'String',num2str(get(hObject,'Value')));
    return;
end;
if a<lowlimit,
    a=lowlimit;
end;
if a>highlimit
    a=highlimit;
end;
set(hObject,'Value',a);
set(hObject,'String',num2str(a));
