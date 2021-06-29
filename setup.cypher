//create index
create index on :Tweet(id);
create index on :User(user_id);

//load data
CALL apoc.load.json("file:///tweets.json")
YIELD value
MERGE (t:Tweet {id: value.id})
MERGE (u:User {user_id: value.user_id})
MERGE (u)-[:CREATED]->(t);

CALL apoc.load.json("file:///tweets.json")
YIELD value where value.user_mentions is not null
UNWIND value.user_mentions AS user_mention
MATCH (t:Tweet {id: value.id})
MERGE (u:User {user_id: user_mention.id})
MERGE (t)-[:MENTION]->(u);

CALL apoc.load.json("file:///tweets.json")
YIELD value where value.retweet_id is not null
MATCH (t:Tweet {id: value.id})
MERGE (ret:Tweet {id: value.retweet_id})
MERGE (t)-[:RETWEET]->(ret);

CALL apoc.load.json("file:///tweets.json")
YIELD value where value.replyto_id is not null
MATCH (t:Tweet {id: value.id})
MERGE (rep:Tweet {id: value.replyto_id})
MERGE (t)-[:REPLY_TO]->(rep);

CALL apoc.load.json("file:///tweets.json")
YIELD value where value.retweet_user_id is not null
MATCH (t:Tweet {id: value.id})
MERGE (retu:User {user_id: value.retweet_user_id})
MERGE (t)-[:RETWEET]->(retu);

CALL apoc.load.json("file:///tweets.json")
YIELD value where value.replyto_user_id is not null
MATCH (t:Tweet {id: value.id})
MERGE (repu:User {user_id: value.replyto_user_id})
MERGE (t)-[:REPLY_TO]->(repu);

CALL apoc.load.json("file:///tweets.json")
YIELD value where value.hash_tags is not null
UNWIND value.hash_tags AS hash_tag
MERGE (t:Tweet {id: value.id})
MERGE (ht:HashTag {name:hash_tag.text})
MERGE (t)-[:HAS_TAG_OF]->(ht);



