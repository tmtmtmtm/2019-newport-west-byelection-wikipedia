module.exports = names => `
  SELECT DISTINCT ?name ?item ?itemLabel ?election ?electionLabel ?constituency ?constituencyLabel ?party ?partyLabel
  WHERE {
    VALUES ?name { ${names} }
    ?item wdt:P31 wd:Q5 ; rdfs:label ?name .
    { # A person can have a 'candidate in election' statement to an election
      ?item p:P3602 ?es .
      ?es ps:P3602 ?election .
      OPTIONAL { ?es pq:P768 ?constituency }
      OPTIONAL { ?election p:P541/pq:P768 ?constituency }
      OPTIONAL { ?es pq:P102|pq:P1268|pq:P4100 ?party }
    } UNION { # or an election can have a 'candidate' statement to the person
      ?election p:P726 ?es .
      ?es ps:P726 ?item .
      OPTIONAL { ?election p:P541/pq:P768 ?constituency }
      OPTIONAL { ?es pq:P102|pq:P1268|pq:P4100 ?party }
    }
    SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
  }
  ORDER BY ?name ?electionLabel
`
