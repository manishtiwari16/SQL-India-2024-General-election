
create database Election

select * from constituencywise_results     
select * from constituencywise_details
select * from states
select * from statewise_results
select * from partywise_results


--Total seats
select distinct count(parliament_constituency)as total_seats from constituencywise_results


--what are the total number  of seats  available for election in each state
select states.State,count(s.Constituency)as total_seats from constituencywise_results c 
join statewise_results s on c.Parliament_Constituency=s.Parliament_Constituency
join states on s.State_ID=states.State_ID
group by states.State
order by total_seats desc


--seats won by NDA allience party

select
	   sum(case 
	        when party in('Bharatiya Janata Party - BJP',	
'AJSU Party - AJSUP',	
'Apna Dal (Soneylal) - ADAL',	
'Asom Gana Parishad - AGP',		
'Janata Dal  (Secular) - JD(S)',	
'Janata Dal (United) - JD(U)',	
'Lok Janshakti Party(Ram Vilas) - LJPRV',	
'Nationalist Congress Party - NCP',	
'Shiv Sena - SHS',	
'Sikkim Krantikari Morcha - SKM',	
'Telugu Desam - TDP',		
'Hindustani Awam Morcha	(secular) - HAMS',	
'Janasena Party - JnP',	
'Rashtriya Lok Dal - RLD') then [Won]
else 0
END) as winning_seats
from  partywise_results




--Seats Won by NDA Allianz Parties

SELECT 
    party as Party_Name,
    won as Seats_Won
FROM 
    partywise_results
WHERE 
    party IN (
        'Bharatiya Janata Party - BJP', 
        'Telugu Desam - TDP', 
		'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS', 
        'AJSU Party - AJSUP', 
        'Apna Dal (Soneylal) - ADAL', 
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS', 
        'Janasena Party - JnP', 
		'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV', 
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD', 
        'Sikkim Krantikari Morcha - SKM'
    )
ORDER BY Seats_Won DESC


--Add new column field in table partywise_results to get the Party Allianz as NDA, I.N.D.I.A and OTHER

select * from partywise_results

alter table partywise_results
add party_alliance varchar(100)

update partywise_results set party_alliance='NDA' where party in(

    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM')


update partywise_results set party_alliance='I-N-D-I-A' where party in(
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',	
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK')
		

update partywise_results set party_alliance='OTHERS' where party_alliance IS NULL

select * from partywise_results





--Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states?

select party_alliance,sum(Won) as seats from partywise_results group by party_alliance order by seats desc






--Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency?

select c.Winning_Candidate,states.State,p.Party,c.Total_Votes,c.Margin,s.constituency
from constituencywise_results as c
join partywise_results as p on c.party_id=p.Party_ID
join statewise_results as s on c.Parliament_Constituency=s.Parliament_Constituency
join states on s.State_ID=states.State_ID
WHERE states.State = 'Uttar Pradesh' AND c.Constituency_Name = 'AMETHI'








--What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?
select   
    d.Candidate,
    d.Party,
    d.EVM_Votes,
    d.Postal_Votes,
    d.Total_Votes,
    c.Constituency_Name
from constituencywise_results as c 
join constituencywise_details as d on c.Constituency_ID=d.Constituency_ID
where c.Constituency_Name='mathura'
ORDER BY d.Total_Votes DESC;




--Which parties won the most seats in State, and how many seats did each party win?

select p.Party,count(c.Constituency_Name)as seats from partywise_results as p 
join constituencywise_results as c on p.Party_ID=c.Party_ID
join statewise_results s on s.Parliament_Constituency=c.Parliament_Constituency
join states on states.State_ID=s.State_ID
where states.State='madhya pradesh'
group by p.Party
order by seats desc








--What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024

select states.State,
    SUM(CASE WHEN p.party_alliance = 'NDA' THEN 1 ELSE 0 END) as NDA_Seats_Won,
    SUM(CASE WHEN p.party_alliance = 'I-N-D-I-A' THEN 1 ELSE 0 END) AS INDIA_Seats_Won,
	SUM(CASE WHEN p.party_alliance = 'OTHER' THEN 1 ELSE 0 END) AS OTHER_Seats_Won
from partywise_results as p
join constituencywise_results as c on p.Party_ID=c.Party_ID
join statewise_results as s on s.Parliament_Constituency=c.Parliament_Constituency
join states on states.State_ID=s.State_ID
group by states.State







--Which candidate received the highest number of EVM votes in each constituency (Top 10)?

select top 10 cd.Candidate,cr.Constituency_Name,cr.Constituency_ID,cd.EVM_Votes from constituencywise_results as cr
join constituencywise_details as cd on cr.Constituency_ID=cd.Constituency_ID
order by 4 desc






--For the state of Maharashtra, what are the total number of seats,

select states.State,count(cr.Parliament_Constituency)as seats_in_maharshtra from constituencywise_results cr
join statewise_results sr on cr.Parliament_Constituency=sr.Parliament_Constituency
join states on states.State_ID=sr.State_ID
group by states.State
having states.State='Maharashtra'






--For the state of Maharashtra, what are the total number of seats, total number of candidates,
--total number of candidates, total number of parties,
--total votes (including EVM and postal), and the breakdown of EVM and postal votes?

select 
count(distinct c.Constituency_ID)as total_seats,
count(distinct cd.Candidate)as total_candidate,
count(distinct cd.Party)as total_parties,
sum(cd.EVM_Votes)+sum(cd.postal_votes) as total_votes,
sum(cd.EVM_Votes)as evm_votes,
sum(cd.Postal_Votes)as postal_votes
from constituencywise_results as c
join constituencywise_details cd on c.Constituency_ID=cd.Constituency_ID
join partywise_results as p on c.party_id=p.Party_ID
join statewise_results as s on c.Parliament_Constituency=s.Parliament_Constituency
join states on s.State_ID=states.State_ID
where states.State='Maharashtra'










