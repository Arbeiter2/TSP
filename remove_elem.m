function NewA = remove_elem(OldA, elem)
    NewA = OldA;
    idx = find(OldA == Elem, 1);
    if ~isempty(idx)
        NewA(idx:idx) = [];
    end
% end function