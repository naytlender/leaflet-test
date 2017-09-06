class CreateFields < ActiveRecord::Migration[5.0]
  def change
    create_table :fields do |t|
      t.string :name
      t.multi_polygon :shape, geographic: true, srid: 4326

      t.timestamps
    end
    add_index :fields, :shape, using: :gist
  end
end
