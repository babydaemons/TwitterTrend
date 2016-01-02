USE twitter_trend_production;

CREATE TABLE tweets (
   id bigint(20) NOT NULL,
   screen_name varchar(255) NOT NULL,
   profile_image_url varchar(1024) NOT NULL,
   text varchar(1024) NOT NULL,
   tweet_at datetime NOT NULL,
   PRIMARY KEY  (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
