library(pins)

my_local_board <- board_local()

my_local_board %>% pin_list()

# download file we uploaded in other session

pin_download(my_local_board, "message_in_bottle")

# doh! that just gives me a path not a file!

path_to_my_file <- pin_download(my_local_board, "message_in_bottle")

message <- readLines(path_to_my_file)
write(message, "message_in_new_session.txt")
