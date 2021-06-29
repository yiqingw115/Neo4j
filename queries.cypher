//Question 1
MATCH (t:Tweet)
WHERE NOT exists( (t)-[:RETWEET|REPLY_TO]-(:Tweet) )
RETURN count(DISTINCT t) AS Q1_results;

//Question 2
MATCH (t:Tweet)-[:HAS_TAG_OF]->(ht:HashTag)
WHERE NOT exists( (t)-[:RETWEET]->(:Tweet) )
RETURN ht.name AS Q2_tag, count(*) AS tag_count
ORDER BY tag_count DESC LIMIT 5;

//Question 3
MATCH (childt:Tweet)-[:RETWEET|REPLY_TO*]->(parentt:Tweet)
RETURN parentt.id AS Q3_root_id, count(childt) AS descendant_count
ORDER BY descendant_count DESC LIMIT 1;

//Question 4
MATCH (u:User)-[CREATED]->(childt:Tweet)-[:RETWEET|REPLY_TO*]->(parentt:Tweet)
RETURN parentt.id AS Q4_root_id, count(DISTINCT u.user_id) AS user_count
ORDER BY user_count DESC LIMIT 1;

//Question 5
MATCH p=(:Tweet)<-[:RETWEET|REPLY_TO*]-(:Tweet)
WITH length(p) AS Q5_length,nodes(p) AS Tweetts
ORDER BY Q5_length DESC LIMIT 1
UNWIND Tweetts AS tweet
RETURN Q5_length, collect(tweet.id) AS tweets;

//Question 6
MATCH (mentionu:User)<-[mentionr:MENTION]-(childt:Tweet)
WHERE exists{
	       MATCH (childt)-[:RETWEET|REPLY_TO*]->(ru:User)
                       WHERE mentionu.user_id<>ru.user_id
	}
RETURN mentionu.user_id AS user_id, count(mentionu) AS mention_count
ORDER BY mention_count DESC LIMIT 1;
