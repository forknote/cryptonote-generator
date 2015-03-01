import fileinput
import sys
import re
import json
import argparse

def getlines(fobj,line1,line2):
     for line in iter(fobj.readline,''):  #This is necessary to get `fobj.tell` to work
         yield line
         if line == line1:
             pos = fobj.tell()
             next_line = next(fobj):
             fobj.seek(pos)
             if next_line == line2:
                 return

parser = argparse.ArgumentParser()

parser.add_argument('--config', action='store', dest='config_file',
                    default='config.json',
                    help='Configuration filename. Format: json'
                    )
parser.add_argument('--source', action='store', dest='source',
					default='tmp',
                    help='Working folder containing the base coin source'
                    )
args = parser.parse_args()

json_data=open(args.config_file)
config = json.load(json_data)
json_data.close()

paths = {}

# Make changes in src/wallet/wallet_rpc_server_commans_defs.h
paths['wallet_rpc_server_commans_defs_h'] = args.source + "/src/wallet/wallet_rpc_server_commans_defs.h"


# Make changes in src/wallet/wallet_rpc_server.cpp
paths['wallet_rpc_server_cpp'] = args.source + "/src/wallet/wallet_rpc_server.cpp"

wallet_rpc_server_cpp_string1 = """rpc_payment.payment_id   = req.payment_id;"""
wallet_rpc_server_cpp_string2 = """
bool wallet_rpc_server::on_getaddress(const wallet_rpc::COMMAND_RPC_GET_ADDRESS::request& req, wallet_rpc::COMMAND_RPC_GET_ADDRESS::response& res, epee::json_rpc::error& er, connection_context& cntx)
  {
try
    {
//      res.address = m_wallet.get_account().get_keys().m_account_address;
      res.address = getAccountAddressAsStr(m_wallet.currency().publicAddressBase58Prefix(), m_wallet.get_account().get_keys().m_account_address);
    }
catch (std::exception& e)
    {
      er.code = WALLET_RPC_ERROR_CODE_UNKNOWN_ERROR;
      er.message = e.what();
return false;
    }
return true;
  }
bool wallet_rpc_server::on_get_bulk_payments(const wallet_rpc::COMMAND_RPC_GET_BULK_PAYMENTS::request& req, wallet_rpc::COMMAND_RPC_GET_BULK_PAYMENTS::response& res, epee::json_rpc::error& er, connection_context& cntx)
  {
    res.payments.clear();
/* If the payment ID list is empty, we get payments to any payment ID (or lack thereof) */
if (req.payment_ids.empty())
    {
      std::list<std::pair<crypto::hash,wallet2::payment_details>> payment_list;
      m_wallet.get_payments(payment_list, req.min_block_height);
for (auto & payment : payment_list)
      {
        wallet_rpc::payment_details rpc_payment;
        rpc_payment.payment_id   = epee::string_tools::pod_to_hex(payment.first);
        rpc_payment.tx_hash      = epee::string_tools::pod_to_hex(payment.second.m_tx_hash);
        rpc_payment.amount       = payment.second.m_amount;
        rpc_payment.block_height = payment.second.m_block_height;
        rpc_payment.unlock_time  = payment.second.m_unlock_time;
        res.payments.push_back(std::move(rpc_payment));
      }
return true;
    }
for (auto & payment_id_str : req.payment_ids)
    {
      crypto::hash payment_id;
      cryptonote::blobdata payment_id_blob;
// TODO - should the whole thing fail because of one bad id?
if(!epee::string_tools::parse_hexstr_to_binbuff(payment_id_str, payment_id_blob))
      {
        er.code = WALLET_RPC_ERROR_CODE_WRONG_PAYMENT_ID;
        er.message = "Payment ID has invalid format: " + payment_id_str;
return false;
      }
if(sizeof(payment_id) != payment_id_blob.size())
      {
        er.code = WALLET_RPC_ERROR_CODE_WRONG_PAYMENT_ID;
        er.message = "Payment ID has invalid size: " + payment_id_str;
return false;
      }
      payment_id = *reinterpret_cast<const crypto::hash*>(payment_id_blob.data());
      std::list<wallet2::payment_details> payment_list;
      m_wallet.get_payments(payment_id, payment_list, req.min_block_height);
for (auto & payment : payment_list)
      {
        wallet_rpc::payment_details rpc_payment;
        rpc_payment.payment_id   = payment_id_str;
        rpc_payment.tx_hash      = epee::string_tools::pod_to_hex(payment.m_tx_hash);
        rpc_payment.amount       = payment.m_amount;
        rpc_payment.block_height = payment.m_block_height;
        rpc_payment.unlock_time  = payment.m_unlock_time;
        res.payments.push_back(std::move(rpc_payment));
      }
    }
return true;
  }
}"""

with open(paths['wallet_rpc_server_cpp']) as fin, open('output','w') as fout:
    fout.writelines(getlines(fin,'wallet_rpc::payment_details rpc_payment;\n','\n'))
    fout.write(string1 + '\n')
    fout.writelines(fin)
fout.close()

# Make changes in src/wallet/wallet_rpc_server.h
paths['wallet_rpc_server_h'] = args.source + "/src/wallet/wallet_rpc_server.h"


# Make changes in src/wallet/wallet2.cpp
paths['wallet2_cpp'] = args.source + "/src/wallet/wallet2.cpp"

# Make changes in src/wallet/wallet2.h
paths['wallet2_h'] = args.source + "/src/wallet/wallet2.h"
