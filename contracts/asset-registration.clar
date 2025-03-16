;; Asset Registration
;; This contract handles the registration and tracking of park assets

(define-data-var last-asset-id uint u0)

(define-map assets
  { asset-id: uint }
  {
    name: (string-ascii 100),
    asset-type: (string-ascii 50),
    location: (string-ascii 100),
    installation-date: uint,
    last-maintenance: uint,
    status: (string-ascii 20)
  }
)

(define-public (register-asset
    (name (string-ascii 100))
    (asset-type (string-ascii 50))
    (location (string-ascii 100))
    (installation-date uint))
  (let ((new-id (+ (var-get last-asset-id) u1)))
    (begin
      (var-set last-asset-id new-id)
      (map-set assets
        { asset-id: new-id }
        {
          name: name,
          asset-type: asset-type,
          location: location,
          installation-date: installation-date,
          last-maintenance: u0,
          status: "active"
        }
      )
      (ok new-id)
    )
  )
)

(define-public (update-asset-status
    (asset-id uint)
    (status (string-ascii 20)))
  (let ((asset (map-get? assets { asset-id: asset-id })))
    (if (is-some asset)
      (begin
        (map-set assets
          { asset-id: asset-id }
          (merge (unwrap-panic asset) { status: status })
        )
        (ok true)
      )
      (err u404) ;; Asset not found
    )
  )
)

(define-public (update-last-maintenance
    (asset-id uint)
    (maintenance-date uint))
  (let ((asset (map-get? assets { asset-id: asset-id })))
    (if (is-some asset)
      (begin
        (map-set assets
          { asset-id: asset-id }
          (merge (unwrap-panic asset) { last-maintenance: maintenance-date })
        )
        (ok true)
      )
      (err u404) ;; Asset not found
    )
  )
)

(define-read-only (get-asset (asset-id uint))
  (map-get? assets { asset-id: asset-id })
)

(define-read-only (get-last-asset-id)
  (var-get last-asset-id)
)
