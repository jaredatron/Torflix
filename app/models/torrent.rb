class Torrent

  def self.search(query)
    Torrentz.search(query)
  end

  def self.find(id)
    {
      id: id,
      magnet_link: Torrentz.find_magnet_link(id),
    }
  end

end
