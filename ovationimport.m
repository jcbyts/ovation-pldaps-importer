% ===================================
% Ovation Import for PLDAPS Users
% ===================================
% 
% Outline for an automated input script to get the PDS and plx
% files from an experiment into Ovation. At the end of an experiment a user
% will want to import the data. 

%% Connect to the database
connectionfile = '/Users/jacobyates/ovation_databases/local/nhb_rig1_jnk/rig1_test.connection';
user           = 'jacob';

context = NewDataContext(connectionfile, user);





%% Put the user inputs up front so they can change what matters for the day
% Some of these will change from day to day. Some will remain constant
% throughout the course of an entire project. Lets put them at the front of
% the import script so the experimenter can easily change inputs.

% Which files are being imported -- there will usually be multiple pds
% files from a day and multiple plx files. The experimentor will convert
% all plx files into matlab friendly versions before running this script. 
% Mapping
user.pdsfile            = './data/pat020212saccadeMapping1427.PDS';
user.plxmatfile         = './data/pat020212saccadeMapping1427-02.mat';
user.plxfile            = './data/pat020212saccadeMapping1427-02.plx';
% Decision 
user.pdsdecisionfile = '';
user.anotherplxmatfile = '?';


% Some sort of qualitative flag for how the experiment went 
user.quality            = 'good'; % ('bad')
% User specifies how many cells there were
user.numbercells        = 3;
% User specifies the [channel unit] position for each good unit
user.goodpos            = [3 2; 3 3; 4 2];
% sources that change daily -- the location in the grid
user.gridlocations      = {'L3P0', 'L1P2'};


user.timezone    = 'America/Chicago';
% number of trials to use. This should be all trials, but for testing
% purposes, it could be set to something else. 
user.ntrials     = 45;

% Project level information 
user.projectname        = 'LIP multineuron';
user.projectdescription = 'Detailed multi-neuron coding of decisions in parietal cortex';
user.username           = 'jacob';
user.keywords           = {'LIP', 'decision', 'temporal integration', 'GLM', 'reverse correlation'};
user.subject            = 'pat';
user.chamber            = {'LIP-right', 'MT-right'};

% Device information (also won't change) (I took this from the ovation code
% that barry wrote)
devices.psychToolbox = experiment.externalDevice('PsychToolbox', 'Huk lab');
devices.psychToolbox.addProperty('psychtoolbox version', '3.0.8');
devices.psychToolbox.addProperty('matlab version', 'R2009a 32bit');
devices.datapixx = experiment.externalDevice('DataPixx', 'VPixx Technologies');
devices.monitor = experiment.externalDevice('Monitor LH 1080p', 'LG');
devices.monitor.addProperty('resolution', NumericData([1920, 1080]));
devices.eye_tracker = experiment.externalDevice('Eye Trac 6000', 'ASL');
devices.eye_tracker_timer = experiment.externalDevice('Windows', 'Microsoft');




%% this creates a local database -- it won't be in the final script
% ovation.util.createLocalOvationDatabase('ovation', ...
% 'ovation_test',...
% 'jacob',...
% 'password',...
% '/opt/object/mac86_64/oolicense.txt',...
% 'UT::Huk');

%% Connecting to the Ovation database
% ==================================
% Connect to the newly created database as the username "jacob" 
% (password: password) by calling the ovation.NewDataContext function. 
% Enter "password" (no quotes) when prompted for a password.
databasepath = 'gotta make a database';
context = ovation.NewDataContext(databasepath, 'jacob');

% This function returns a DataContext object which acts as a workspace for 
% interacting with objects from the database.

%% Adding to the database
% ======================
%
%% 1) check if project exists? add it if it doesn't?
% get the projects that have the right name
projects = context.getProjects(user.projectname);

%% 2) add an experiment
% the experiment structure is at the level below projects. In our case,
% each day is probably one experiment. 
experiment = project.insertExperiment('experiment name', datetime(2012, 2, 2));
% Experiments have sources. Sources are where the data comes from. In this
% case, the sources can be the subject, a chamber, a grid location, etc. 

%TODO: use sourceForInsertion
pat = context.insertSource('monkey');
pat.addProperty('name', user.subject);

% i specified multiple possible chambers and multiple grid locations above.
% I don't know the best way to handle that here
LIPright = pat.insertSource(user.chamber{i});
src = LIPright.insertSource(user.gridlocations{i});


%% 3) adding the epoch groups
% epoch groups are the set of trials contained by one file. One epoch group
% will have a set of epochs (trials). Each epoch group should, in our case,
% have a PDS file and a plx.mat file to go with it


% import for all pds files specified (mapping, decision, etc.)
% Import PDS
epochGroup = ImportPladpsPDS(experiment,...
    src,...
    user.pdsfile,...
    user.timezone, user.ntrials);

% Import PLX
ImportPLX(epochGroup,...
    user.plxmatfile, ...
    user.plxfile, ...
    user.ntrials);




    






