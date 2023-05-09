install.packages("tidytext")
install.packages("dplyr")
install.packages("wordcloud")
install.packages("tm")
install.packages("ggplot2")

# loading libraries
library(tidytext)
library(dplyr)
library(ggplot2)
library(tm)
library(wordcloud)
library(SnowballC)

# Read data
data <- read.csv("C:\\Users\\sasik\\OneDrive\\Desktop\\project pds 3\\data_raw\\Corona_NLP_test.csv", stringsAsFactors = FALSE)

# Preprocessing
# Removing url's
data$OriginalTweet <- gsub("http[^[:space:]]*", "", data$OriginalTweet)
# Remove mentions
data$OriginalTweet <- gsub("@[^[:space:]]*", "", data$OriginalTweet)
# Remove non-alphanumeric characters
data$OriginalTweet <- gsub("[^[:alnum:][:space:]']", "", data$OriginalTweet)
# Convert text to lowercase
data$OriginalTweet <- tolower(data$OriginalTweet)
# Remove null values
data <- data[!is.na(data$OriginalTweet) & data$OriginalTweet != "", ]

# Save cleaned data to a new CSV file
write.csv(data, "C:\\Users\\sasik\\OneDrive\\Desktop\\project pds 3\\Cleaned_Carona_NLP_test.csv", row.names = FALSE)

data <- read.csv("C:\\Users\\sasik\\OneDrive\\Desktop\\project pds 3\\Cleaned_Carona_NLP_test.csv", stringsAsFactors = FALSE)


# Tokenization
tokens <- data %>%
  unnest_tokens(word, OriginalTweet)

print(tokens)
write.csv(tokens, "C:\\Users\\sasik\\OneDrive\\Desktop\\project pds 3\\results/tokens.csv", row.names = FALSE)


# Stopword removal
data_stopwords <- stop_words
tokens_no_stopwords <- tokens %>%
  anti_join(data_stopwords, by = "word")

print(tokens_no_stopwords)
write.csv(tokens_no_stopwords, "C:\\Users\\sasik\\OneDrive\\Desktop\\project pds 3\\results\\tokens_no_stopwords.csv", row.names = FALSE)


# Count word frequencies
word_freq <- tokens_no_stopwords %>%
  count(word, sort = TRUE)

print(word_freq)
write.csv(word_freq, "C:\\Users\\sasik\\OneDrive\\Desktop\\project pds 3\\results\\word_freq.csv", row.names = FALSE)


# Create word cloud
png("C:\\Users\\sasik\\OneDrive\\Desktop\\project pds 3\\results\\wordcloud.png", width = 800, height = 800, units = "px")
wordcloud(words = word_freq$word, freq = word_freq$n, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35,
          colors = brewer.pal(8, "Dark2"))
dev.off()