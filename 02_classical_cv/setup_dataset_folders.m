function setup_dataset_folders()

base = "data";
classes = ["X","O","Other"];

if ~exist(base, "dir")
    mkdir(base);
end

for c = classes
    folder = fullfile(base, c);
    if ~exist(folder, "dir")
        mkdir(folder);
    end
end

disp("Folders ready: data\X, data\O, data\Other");
end
