CREATE  (shabaab:Group { name : "Al-Shabaab" , aka : "AL-SHABAAB AL-ISLAAM, AL-SHABAAB AL-ISLAMIYA", year_founded: 2006, type: "militant"}),
        (hizb:Group { name : "Hizb al Islam", type: "militant" }),

        (godane:Person { name:"Ahmed Abdi Godane", aka: "Mukhtar Abu Zubair"}),
        (sheikh:Person { name:"Sheikh Mukhtar Robow", aka: "Abu Mansur"}),
        (rage:Person { name:"Ali Mohamed Rage", aka: "Ali Dhere"}),
        (aweys:Person { name:"Hassan Dahir Aweys"}),
        (qalaf:Person { name:"Fuad Mohamed Qalaf", aka: "Shongole"}),
        (mead:Person { name:"Ibrahim Haji Jama Mead", aka: "Ibrahim al Afghani"}),

        (kenyatta:Person { name:"Uhuru Kenyatta", dob: "1961-10-26" }),
        (ruto:Person { name:"William Ruto", dob: "1966-12-21"}),

        (godane)-[:MEMBER_OF { role : "Leader", status: "Current" }]->(shabaab),
        (sheikh)-[:MEMBER_OF { role : "Deputy Leader", status: "Current" }]->(shabaab),
        (rage)-[:MEMBER_OF { role : "Spokesman", status: "Current" }]->(shabaab),
        (aweys)-[:MEMBER_OF { role : "Senior Member", status: "Current" }]->(shabaab),
        (qalaf)-[:MEMBER_OF { role : "Senior Member", status: "Current" }]->(shabaab),
        (mead)-[:MEMBER_OF { role : "Senior Member", status: "Current" }]->(shabaab),
        (aweys)-[:MEMBER_OF { role : "Leader", status: "Former" }]->(hizb),

        (somalia:Country { name : "Somalia"}),
        (shabaab)-[:BASED_IN]->(somalia),
        (hizb)-[:BASED_IN]->(somalia),

        (kenya:Country { name : "Kenya", population: "44,037,656"}),
        (nairobi:City { name : "Nairobi", population: "3,375,000"}),
        (nairobi)-[:LOCATED_IN]->(kenya),
        (nairobi)-[:CAPITAL_OF]->(kenya),

        (kenyatta)-[:LEADERSHIP { role: "President" } ]->(kenya),
        (ruto)-[:LEADERSHIP { role: "Deputy President" } ]->(kenya),

        (westgate:Place { name : "Westgate", type: "Shopping Mall"}),
        (westgate)-[:LOCATED_IN]->(nairobi),

        (mm:Attack { name: "mass murder" }),
        (hc:Attack { name: "hostage crisis" }),
        (sh:Attack { name: "shooting" }),

        (wgattack:Event { name : "Westgate Shopping Mall Attack", start_date: "2013-09-21", end_date: "2013-09-24", killed: 72, injured: 175}),
        (wgattack)-[:OCCURRED_IN]->(westgate),

        (wgattack)-[:INCIDENT_OF]->(sh),
        (wgattack)-[:INCIDENT_OF]->(mm),
        (wgattack)-[:INCIDENT_OF]->(hc),

        (shabaab)-[:PERPETRATOR]->(wgattack),

        (us:Country { name : "United States"}),
        (uk:Country { name : "United Kingdom"}),
        (au:Country { name : "Australia"}),
        (ca:Country { name : "Canada"}),
        (nz:Country { name : "New Zealand"}),
        (eu:Group { name : "European Union", type: "governmental"}),

        (shabaab)-[:DESIGNATION { type: "terrorist group", date: "2008-02-28" } ]->(us),
        (shabaab)-[:DESIGNATION { type: "terrorist group", date: "2010-05-01" } ]->(uk),
        (shabaab)-[:DESIGNATION { type: "terrorist group", date: "2010-04-01" } ]->(eu),
        (shabaab)-[:DESIGNATION { type: "terrorist group", date: "2012-08-18" } ]->(au),
        (shabaab)-[:DESIGNATION { type: "terrorist group", date: "2010-02-01" } ]->(nz),
        (shabaab)-[:DESIGNATION { type: "terrorist group", date: "2010-03-05" } ]->(ca)
      ;
