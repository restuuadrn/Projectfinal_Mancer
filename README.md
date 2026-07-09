# Projectfinal_Mancer
Personal Vault
# Smart Contract Personal Vault

## Deskripsi
Personal Vault adalah smart contract Ethereum yang memungkinkan pemilik menyimpan (deposit) ETH dan menguncinya hingga waktu tertentu (unlock time). Dana hanya dapat ditarik setelah waktu penguncian berakhir.

# Fitur
- Menyimpan (Deposit) ETH
- Menarik (Withdraw) ETH setelah waktu penguncian berakhir
- Memperpanjang waktu penguncian (Extend Lock Time)
- Akses hanya untuk pemilik kontrak (Owner Only)
- Menggunakan Custom Errors
- Menggunakan Events untuk mencatat aktivitas

## Jaringan
Sepolia Testnet

## Alamat Smart Contract
```
0x...............
```

## Verifikasi Kontrak
```
https://sepolia.etherscan.io/address/....
```

## Hasil Pengujian

✅ Deposit ETH berhasil

✅ Penarikan gagal sebelum waktu penguncian berakhir

✅ Penarikan berhasil setelah waktu penguncian berakhir
