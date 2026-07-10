// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PersonalVault {
    // ============ State Variables ============

    // Alamat pemilik vault. immutable = hanya diset sekali di constructor,
    // lebih hemat gas karena disimpan langsung di bytecode, bukan storage.
    address public immutable owner;

    // Timestamp (detik, unix epoch) kapan dana boleh mulai ditarik.
    uint256 public unlockTime;

    // ============ Events ============

    // Dipancarkan tiap kali deposit berhasil. `indexed` biar sender bisa
    // difilter di Etherscan/block explorer.
    event Deposit(address indexed sender, uint256 amount);

    // Dipancarkan tiap kali withdraw berhasil dan dana sudah terkirim ke owner.
    event Withdrawal(uint256 amount, uint256 timestamp);

    // Dipancarkan tiap kali unlockTime berhasil diperpanjang.
    event LockExtended(uint256 newUnlockTime);

    // ============ Custom Errors ============

    error FundsLocked();       // withdraw dipanggil sebelum unlockTime tercapai
    error NotOwner();          // pemanggil bukan owner
    error InvalidUnlockTime(); // waktu baru tidak valid (harus di masa depan / lebih besar)
    error NoFunds();           // deposit 0 ETH, atau saldo vault kosong saat withdraw
    error TransferFailed();    // transfer ETH ke owner gagal

    // Membatasi fungsi hanya bisa dipanggil owner.
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // Deploy vault + set unlock time awal.
    // WAJIB validasi _unlockTime > sekarang, kalau tidak vault bisa langsung
    // dibuka tanpa benar-benar terkunci (Common Pitfall dari studi kasus).
    // payable: owner boleh langsung isi vault saat deploy (opsional).
    constructor(uint256 _unlockTime) payable {
        if (_unlockTime <= block.timestamp) {
            revert InvalidUnlockTime();
        }

        owner = msg.sender;
        unlockTime = _unlockTime;
    }

    // Owner deposit ETH ke vault. Dibatasi onlyOwner karena ini vault pribadi
    // (bukan bagian wajib brief, tapi pilihan desain yang masuk akal).
    function deposit() external payable onlyOwner {
        if (msg.value == 0) {
            revert NoFunds();
        }

        emit Deposit(msg.sender, msg.value);
    }

    // Tarik SELURUH saldo vault ke owner, hanya setelah unlockTime lewat.
    // Urutan: cek waktu -> cek owner (modifier) -> cek saldo -> transfer -> emit.
    function withdraw() external onlyOwner {
        if (block.timestamp < unlockTime) {
            revert FundsLocked();
        }

        uint256 amount = address(this).balance;

        if (amount == 0) {
            revert NoFunds();
        }

        // Transfer dulu pakai call{value} (best practice, gas tidak dibatasi
        // seperti transfer()/send()), baru emit setelah dipastikan sukses.
        (bool success, ) = payable(owner).call{value: amount}("");

        if (!success) {
            revert TransferFailed();
        }

        emit Withdrawal(amount, block.timestamp);
    }

    // Perpanjang waktu unlock. TIDAK BOLEH mempersingkat (newTime harus > unlockTime).
    // WAJIB update state unlockTime sebelum emit, biar event tidak "bohong"
    // (Common Pitfall dari studi kasus: event di-emit tapi state tidak berubah).
    function extendLock(uint256 newTime) external onlyOwner {
        if (newTime <= unlockTime) {
            revert InvalidUnlockTime();
        }

        unlockTime = newTime;

        emit LockExtended(newTime);
    }

    // Cek saldo ETH yang saat ini tersimpan di vault.
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
