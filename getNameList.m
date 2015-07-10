function list = getNameList(structure)

    for i = 1 : length(structure)
        list{i} = structure{i}.name;
    end