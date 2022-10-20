
;; warsaw-coliving
;; this is a simulation of the tokenization of a real estate property in Warsaw, Poland

;; explicitly assert conformity with depending traits.
(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; constants
;; contract deployer
(define-constant contract-owner tx-sender)

;; constant errors
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; data maps and vars
;; define NFT's unique asset name (per contract) and asset identifier
(define-non-fungible-token warsaw-coliving uint)
;; increment a counter variable each time a new NFT is minted
(define-data-var last-token-id uint u0)

;; private functions
;;

;; public functions
;; track the last token ID
(define-read-only (get-last-token-id) 
    (ok (var-get last-token-id))
)
;; return a link to the metadata of a specified NFT (or none)
(define-read-only (get-token-uri (token-id uint)) 
    (ok none)
)
;; wrap the built-in nft-get-owner? function
(define-read-only (get-owner (token-id uint)) 
    (ok (nft-get-owner? warsaw-coliving token-id))
)
;; transfer function should assert that sender == tx-sender.
(define-public (transfer (token-id uint) (sender principal) (recipient principal)) 
    (begin
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        ;; #[filter(token-id, recipient)]
        (nft-transfer? warsaw-coliving token-id sender recipient)
    )
)
;; minting function must prevent others than contract-owner to mint new tokens
(define-public (mint (recipient principal)) 
    (let 
        (
            (token-id (+ (var-get last-token-id) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        ;; #[filter(recipient)]
        (try! (nft-mint? warsaw-coliving token-id recipient))
        (var-set last-token-id token-id)
        (ok token-id)
    )
)
