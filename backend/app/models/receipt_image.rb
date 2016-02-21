class ReceiptImage < Image
  belongs_to :receipt, foreign_key: 'reference_id'
end
