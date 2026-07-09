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
0xf4ff159778fbc24944fdd4c6ec7678d0df55a19b
```

## Verifikasi Kontrak
```
https://sepolia.etherscan.io/address/0x1C150285ccE903c79FBf65203d96e38da537aC20
```

## Hasil Pengujian

✅ Deposit ETH berhasil

✅ Penarikan gagal sebelum waktu penguncian berakhir

✅ Penarikan berhasil setelah waktu penguncian berakhir

## Hash Transaksi
### Deposit Berhasil
https://sepolia.etherscan.io/tx/0x122b11cb78e42e11ecb360c39847a47f08e47e9614fc222f15f03adee915d534

### Withdraw Berhasil
https://sepolia.etherscan.io/tx/0xe2b81281f11b0362e6a4ff2922db471f6f289e1d53ba35bc0239c88a6af83951

### Withdraw Gagal
https://sepolia.etherscan.io/tx/0x14dab909258a8213f3254707e3b17f10e33edd9e4c879efb2b83f4a5e86efa76
