%ifndef FT_LIST_S
    %define FT_LIST_S

struc   ft_list
    ft_list_data:   resq    1
    ft_list_next:   resq    1
endstruc

%define data_of(x) [x + ft_list_data]
%define next_of(x) [x + ft_list_next]

%endif
