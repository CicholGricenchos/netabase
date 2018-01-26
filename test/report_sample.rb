Report.new(
  schema: {
    source: 'FROM products WHERE created_at > #{begin_date} AND created_at < #{end_date}',
    params: {
      begin_date: {
        type: :date,
        default: 1.year.ago
      },
      end_date: {
        type: :date,
        default: Time.now
      }
    },
    output: [:id, :retail_price, :sku_name, :created_at, :updated_at]
  }
)
