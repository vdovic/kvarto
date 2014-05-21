json.array!(@variants) do |variant|
  json.extract! variant, :id, :kimnatYa, :typYa, :mistoYa, :kimnatVin, :typVin, :mistoVin, :description
  json.url variant_url(variant, format: :json)
end
