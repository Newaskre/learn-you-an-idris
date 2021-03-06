module Ex30 

import System.Concurrency.Channels

data Message = Add Nat Nat

adder : IO ()
adder = do Just sender_chan <- listen 1 
           | Nothing => adder
           Just msg <- unsafeRecv Message sender_chan 
           | Nothing => adder
           case msg of 
             (Add k j) => 
             do ok <- unsafeSend sender_chan (k + j)
                adder
           
main : IO ()
main = do Just adder_id <- spawn adder 
          | Nothing => putStrLn "Spawn failed"
          Just chan <- connect adder_id 
          | Nothing => putStrLn "Connection failed"
          ok <- unsafeSend chan (Add 3 4)
          Just answer <- unsafeRecv Nat chan
          | Nothing => putStrLn "Send failed"
          printLn answer
           
