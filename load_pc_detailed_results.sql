--CREATE TABLE PC_Detailed_Results (
--	State varchar(50),
--	pc_name varchar(50),
--	candidate varchar(100),
--	gender varchar(10),
--	age integer,
--	category varchar(10),
--	party varchar(50),
--	party_symbol varchar(50),
--	general_votes_secured Integer,
--	postal_votes_secured Integer,
--	Votes_secured_in_pc Integer,
--	perc_votes_electors float,
--	perc_votes_polled  float,
--	Total_Electors_PC Integer
--);
truncate table pc_detailed_results;
alter table pc_detailed_results drop column year;
alter table pc_detailed_results drop column year_pc_name;

-- change folder name and file name
COPY PC_Detailed_Results(State,PC_Name,Candidate,gender,age,category,party,party_symbol, general_votes_secured,postal_votes_secured, votes_secured_in_pc,perc_votes_electors,perc_votes_polled,total_electors_pc)
FROM 'F:\Ramaa\CoolResearch\IndiaElectionsStudies\LokSabhaElections\2019\LoadAsCSV\ConstituencyWiseDetailedResult.csv'
DELIMITER ','
CSV HEADER;

alter table pc_detailed_results add column year integer;
update pc_detailed_results set year=2019;

alter table pc_detailed_results add year_pc_name VARCHAR(60);
update pc_detailed_results set year_pc_name = concat(year,'-',trim(state),'-',trim(pc_name));

truncate table PC_List;

--create table PC_List (
--  State VARCHAR(50),
--  PC_Name VARCHAR(50),
--  Year Integer
--);

insert into pc_list
select distinct trim(state),trim(pc_name),year from pc_detailed_results;

CREATE TABLE PC_Detailed_Results_rank (
	year integer,	
	State varchar(50),
	pc_name varchar(50),
	candidate varchar(100),
	gender varchar(10),
	age integer,
	category varchar(10),
	party varchar(50),
	party_symbol varchar(50),
	general_votes_secured Integer,
	postal_votes_secured Integer,
	Votes_secured_in_pc Integer,
	perc_votes_electors float,
	perc_votes_polled  float,
	Total_Electors_PC Integer,
	year_pc_name varchar(60),
	vote_rank Integer
);

insert into PC_Detailed_Results_rank
(select p.year,trim(p.State), trim(p.PC_Name),trim(p.candidate),trim(p.gender),p.age,trim(p.category),trim(p.party),trim(p.party_symbol),p.general_votes_secured,p.postal_votes_secured,p.votes_secured_in_pc,p.perc_votes_electors,p.perc_votes_polled,p.total_electors_pc,p.year_pc_name, 
	RANK () OVER (
		PARTITION BY p.year_pc_name
		ORDER BY p.Votes_Secured_In_pc DESC
	) vote_rank 
FROM
	pc_detailed_results p
	JOIN PC_List pa 
		ON trim(p.PC_Name) = trim(pa.PC_Name) and p.year = pa.year and trim(p.state)=trim(pa.state));
